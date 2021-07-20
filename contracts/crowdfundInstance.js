/* eslint-disable */
import web3 from './web3';

const address = '0xA895D022271229f3F9788828442Ab5A43e0CaF58'
const abi = [
    {
      "anonymous": false,
      "inputs": [
        {
          "indexed": false,
          "internalType": "address",
          "name": "contractAddress",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "address",
          "name": "projectStarter",
          "type": "address"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "deadline",
          "type": "uint256"
        },
        {
          "indexed": false,
          "internalType": "uint256",
          "name": "goalAmount",
          "type": "uint256"
        }
      ],
      "name": "ProjectStarted",
      "type": "event"
    },
    {
      "inputs": [
        {
          "internalType": "string",
          "name": "projectId",
          "type": "string"
        },
        {
          "internalType": "uint256",
          "name": "durationInDays",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "amountToRaise",
          "type": "uint256"
        },
        {
          "internalType": "address",
          "name": "pk1",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "pk2",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "pk3",
          "type": "address"
        }
      ],
      "name": "startProject",
      "outputs": [],
      "stateMutability": "nonpayable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "returnAllProjects",
      "outputs": [
        {
          "internalType": "contract Project[]",
          "name": "",
          "type": "address[]"
        }
      ],
      "stateMutability": "view",
      "type": "function",
      "constant": true
    }
  ];

const instance = new web3.eth.Contract(abi, address);

export default instance;
