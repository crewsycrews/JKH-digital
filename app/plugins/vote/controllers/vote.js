'use strict';

const Orm = require('bigchaindb-orm').default;
const { v4: uuid } = require('uuid');

const bdbOrm = new Orm(process.env.BLOCKCHAIN_DB_API_PATH);
bdbOrm.define('votes', 'https://schema.org/v1/votes');
// create a public and private key
const keypair = new bdbOrm.driver.Ed25519Keypair();

/**
 * vote.js controller
 *
 * @description: A set of functions called "actions" of the `vote` plugin.
 */

module.exports = {
  // Get some vote blockchain data
  index: async (ctx) => {
    const [blockchain] = await bdbOrm.models.votes.retrieve();
    ctx.send(blockchain.data);
  },

  // Create new vote
  create: async (ctx) => {
    const {
      scope,
      votes = [],
    } = ctx.request.body;

    if (!scope || !votes.length) {
      return ctx.send({
        message: 'Scope and Votes are required!',
      });
    }

    const isCaptionEmpty = votes.filter(({ caption }) => !caption).length;
    if (isCaptionEmpty) {
      return ctx.send({
        message: 'All votes captions are required!',
      });
    }

    const bdbId = uuid();

    const start = new Date();
    const end = new Date(start.getDate() + 2 * 7);

    const scopeEntry = await strapi.query('scopes').create({
      title: scope,
      blockchaindb_id: `id:global:votes:${bdbId}`,
    });

    const voteItems = votes.map(vote => ({
      caption: vote.caption,
      category: vote.category || 'common',
      description: vote.description || '',
      start,
      end,
      scope_id: scopeEntry.id,
      answers: vote.answers || [
        { name: 'yes', title: 'За' },
        { name: 'no', title: 'Против' },
        { name: 'against', title: 'Воздержался' },
      ],
    }));

    const voteEntries = await Promise.all(
      voteItems.map(vote => strapi.query('votes').create({
        caption: vote.caption,
        category: vote.category || 'common',
        description: vote.description || '',
        start,
        end,
        scope_id: vote.scope_id,
        blockchaindb_id: `id:global:votes:${bdbId}`,
      }))
    );

    await bdbOrm.models.votes.create({
      keypair,
      data: {
        votes: voteItems.map(({ scope_id, caption, answers }) => ({
          scope_id,
          caption,
          // vote_id,
          answers,
          state: Object.fromEntries(
            new Map(answers.map(({name}) => [name, 0]))
          ),
        })),
      },
    }, bdbId);

    // Send 200 `ok`
    ctx.send({
      message: 'Vote created successfully!',
      votes: voteEntries,
    });
  },

  // Add user vote
  vote: async (ctx) => {
    const {
      id,
      user_id,
      votes,
    } = ctx.request.body;

    if (!id || !user_id || !votes) {
      return ctx.send({
        message: 'Some required input parameters are missing',
      });
    }

    const [blockchain] = await bdbOrm.models.votes.retrieve(id);

    const prevVotes = blockchain.data.votes;
    const userVotes = votes.map(({ answers }) => ({
      user_id,
      answers,
      state: Object.fromEntries(
        new Map(answers.map(({ name, is_vote }) => [name, is_vote ? 1 : 0]))
      ),
    }));

    await blockchain.append({
      toPublicKey: keypair.publicKey,
      keypair,
      data: {
        user_id,
        votes: userVotes.map(({ state, ...userVote }, i) => ({
          ...prevVotes[i],
          ...userVote,
          state: Object.fromEntries(new Map(
            Object.entries(prevVotes[i].state).map(([key, value]) => [key, value + state[key]])
          )),
        })),
      }
    });

    ctx.send({
      message: 'ok',
    });
  },

  // Get current vote state
  getVote: async (ctx) => {
    const { id } = ctx.params;
    const { user_id } = ctx.query;

    const [blockchain] = await bdbOrm.models.votes.retrieve(id);

    if (!user_id) {
      return ctx.send({
        active: blockchain.data,
      });
    }

    const { transactionHistory } = blockchain;
    const [userTransaction] = transactionHistory.filter(({ metadata }) => metadata.user_id == user_id);

    if (!userTransaction) {
      return ctx.send({
        message: 'User vote not found',
      });
    }

    ctx.send({
      user: userTransaction.metadata,
      active: blockchain.data,
    });
  },
};
