// Copyright 2018 OST.com Ltd.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

'use strict';

const web3 = require('../test_lib/web3.js');
const BN = require('bn.js');

const EIP20TokenFake = artifacts.require('EIP20TokenFake');
const TokenRulesSpy = artifacts.require('TokenRulesSpy');
const Organization = artifacts.require('Organization');
const PricerRule = artifacts.require('PricerRule');
const PriceOracleFake = artifacts.require('PriceOracleFake');

/**
 * Creates an EIP20 instance to be used during TokenRules::executeTransfers
 * function's testing with the following defaults:
 *      - symbol: 'OST'
 *      - name: 'Open Simple Token'
 *      - decimals: 1
 */
module.exports.createEIP20Token = async () => {
  const token = await EIP20TokenFake.new(
    'OST', 'Open Simple Token', 1,
  );

  return token;
};

module.exports.createOrganization = async (accountProvider) => {
  const organizationOwner = accountProvider.get();
  const organizationWorker = accountProvider.get();

  const organization = await Organization.new(
    organizationOwner,
    organizationOwner,
    [organizationWorker],
    (await web3.eth.getBlockNumber()) + 100000,
    { from: accountProvider.get() },
  );

  return {
    organization,
    organizationOwner,
    organizationWorker,
  };
};

/**
 * Creates and returns the tuple:
 *      (tokenRules, organizationAddress, token)
 */
module.exports.createTokenEconomy = async (accountProvider, config = {}) => {
  const {
    organization,
    organizationOwner,
    organizationWorker,
  } = await this.createOrganization(accountProvider);

  const token = await this.createEIP20Token();

  const tokenRules = await TokenRulesSpy.new();

  const baseCurrencyCode = config.baseCurrencyCode || 'OST';

  // (For 1 OST = 1 BT)
  const conversionRate = config.conversionRate || 100000;
  const conversionRateDecimals = config.conversionRateDecimals || 5;

  const requiredPriceOracleDecimals = config.requiredPriceOracleDecimals || 18;

  const pricerRule = await PricerRule.new(
    organization.address,
    token.address,
    web3.utils.stringToHex(baseCurrencyCode.toString()),
    conversionRate,
    conversionRateDecimals,
    requiredPriceOracleDecimals,
    tokenRules.address,
  );

  //console.log("pricerRule:", pricerRule.address);

  const quoteCurrencyCode = 'USD';
  const priceOracleInitialPrice = (0.02 * (10 ** requiredPriceOracleDecimals)).toString(); // $0.02 = 2*10^16(in contract)
  //console.log("priceOracleInitialPrice:", priceOracleInitialPrice);
  const initialPriceExpirationHeight = (await web3.eth.getBlockNumber()) + 10000;

  const priceOracle = await PriceOracleFake.new(
    web3.utils.stringToHex(baseCurrencyCode),
    web3.utils.stringToHex(quoteCurrencyCode),
    requiredPriceOracleDecimals,
    priceOracleInitialPrice,
    initialPriceExpirationHeight,
  );

  return {
    organization,
    organizationOwner,
    organizationWorker,
    token,
    tokenRules,
    baseCurrencyCode,
    conversionRate,
    conversionRateDecimals,
    requiredPriceOracleDecimals,
    pricerRule,
    quoteCurrencyCode,
    priceOracleInitialPrice,
    priceOracle,
  };
};
