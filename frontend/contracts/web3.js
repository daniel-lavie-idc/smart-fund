/* eslint-disable */
import Web3 from 'web3';

if (typeof window.ethereum !== 'undefined') {
  console.log('MetaMask is installed!');
  window.web3 = new Web3(window.ethereum);
  try {
    // Request account access if needed
    ethereum.request({ method: 'eth_requestAccounts' });
  } catch (error) {
    // User denied account access...
  }
} else if (window.web3) {
  // Legacy dapp browsers...
  window.web3 = new Web3(web3.currentProvider);
} else {
  // Non-dapp browsers...
  console.log('Non-Ethereum browser detected. You should consider trying MetaMask!');
}

export default web3;
