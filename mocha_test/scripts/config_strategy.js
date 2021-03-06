'use strict';

const rootPrefix = '../..';

const configStrategy = {
  // Geth
  OST_UTILITY_GETH_RPC_PROVIDER: process.env.OST_UTILITY_GETH_RPC_PROVIDER,
  OST_UTILITY_GETH_WS_PROVIDER: process.env.OST_UTILITY_GETH_WS_PROVIDER,

  CACHING_ENGINE: process.env.OST_CACHING_ENGINE,
  DEBUG_ENABLED: process.env.OST_DEBUG_ENABLED,
  OST_STANDALONE_MODE: process.env.OST_STANDALONE_MODE || 0,

  //Utility
  OST_UTILITY_GAS_PRICE: process.env.OST_UTILITY_GAS_PRICE,
  OST_UTILITY_CHAIN_ID: process.env.OST_UTILITY_CHAIN_ID,
  OST_UTILITY_DEPLOYER_ADDR: process.env.OST_UTILITY_DEPLOYER_ADDR,
  OST_UTILITY_DEPLOYER_PASSPHRASE: process.env.OST_UTILITY_DEPLOYER_PASSPHRASE,
  OST_UTILITY_OPS_ADDR: process.env.OST_UTILITY_OPS_ADDR,
  OST_UTILITY_OPS_PASSPHRASE: process.env.OST_UTILITY_OPS_PASSPHRASE,
  OST_UTILITY_PRICE_ORACLES: process.env.OST_UTILITY_PRICE_ORACLES,
  // OST_AIRDROP_BUDGET_HOLDER: process.env.OST_AIRDROP_BUDGET_HOLDER,
  // OST_AIRDROP_BUDGET_HOLDER_PASSPHRASE: process.env.OST_AIRDROP_BUDGET_HOLDER_PASSPHRASE,

  //Dynamo Config
  OS_DYNAMODB_ACCESS_KEY_ID: process.env.OS_DYNAMODB_ACCESS_KEY_ID,
  OS_DYNAMODB_SECRET_ACCESS_KEY: process.env.OS_DYNAMODB_SECRET_ACCESS_KEY,
  OS_DYNAMODB_ENDPOINT: process.env.OS_DYNAMODB_ENDPOINT,
  OS_DYNAMODB_API_VERSION: process.env.OS_DYNAMODB_API_VERSION,
  OS_DYNAMODB_REGION: process.env.OS_DYNAMODB_REGION,
  OS_DYNAMODB_SSL_ENABLED: process.env.OS_DYNAMODB_SSL_ENABLED,
  OS_DYNAMODB_LOGGING_ENABLED: process.env.OS_DYNAMODB_LOGGING_ENABLED,
  AUTO_SCALE_DYNAMO: process.env.AUTO_SCALE_DYNAMO,

  // Auto Scaling vars
  OS_AUTOSCALING_API_VERSION: process.env.OS_AUTOSCALING_API_VERSION,
  OS_AUTOSCALING_ACCESS_KEY_ID: process.env.OS_AUTOSCALING_ACCESS_KEY_ID,
  OS_AUTOSCALING_SECRET_ACCESS_KEY: process.env.OS_AUTOSCALING_SECRET_ACCESS_KEY,
  OS_AUTOSCALING_REGION: process.env.OS_AUTOSCALING_REGION,
  OS_AUTOSCALING_ENDPOINT: process.env.OS_AUTOSCALING_ENDPOINT,
  OS_AUTOSCALING_SSL_ENABLED: process.env.OS_AUTOSCALING_SSL_ENABLED,
  OS_AUTOSCALING_LOGGING_ENABLED: process.env.OS_AUTOSCALING_LOGGING_ENABLED,

  // Cache variables.
  OST_CACHING_ENGINE: process.env.OST_CACHING_ENGINE,
  OST_CACHE_CONSISTENT_BEHAVIOR: 1
};

module.exports = configStrategy;
