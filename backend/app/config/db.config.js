module.exports = {
    url: process.env.MONGO_URL ? process.env.MONGO_URL : 'mongodb://localhost:27017/crowdfunding_db',
};