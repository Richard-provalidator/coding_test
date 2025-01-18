var Web3 = require("web3");
var web3 = new Web3("wss://sepolida.infura.io/ws/v3/");
var privKey = "";
var account = web3.eth.accounts.privateKeyToAccount(privKey);
web3.eth.accounts.wallet.add(account);
var c_addr = "";
var abi = [
  [
    { inputs: [], stateMutability: "nonpayable", type: "constructor" },
    {
      inputs: [
        { internalType: "address", name: "sender", type: "address" },
        { internalType: "uint256", name: "balance", type: "uint256" },
        { internalType: "uint256", name: "needed", type: "uint256" },
        { internalType: "uint256", name: "tokenId", type: "uint256" },
      ],
      name: "ERC1155InsufficientBalance",
      type: "error",
    },
    {
      inputs: [{ internalType: "address", name: "approver", type: "address" }],
      name: "ERC1155InvalidApprover",
      type: "error",
    },
    {
      inputs: [
        { internalType: "uint256", name: "idsLength", type: "uint256" },
        { internalType: "uint256", name: "valuesLength", type: "uint256" },
      ],
      name: "ERC1155InvalidArrayLength",
      type: "error",
    },
    {
      inputs: [{ internalType: "address", name: "operator", type: "address" }],
      name: "ERC1155InvalidOperator",
      type: "error",
    },
    {
      inputs: [{ internalType: "address", name: "receiver", type: "address" }],
      name: "ERC1155InvalidReceiver",
      type: "error",
    },
    {
      inputs: [{ internalType: "address", name: "sender", type: "address" }],
      name: "ERC1155InvalidSender",
      type: "error",
    },
    {
      inputs: [
        { internalType: "address", name: "operator", type: "address" },
        { internalType: "address", name: "owner", type: "address" },
      ],
      name: "ERC1155MissingApprovalForAll",
      type: "error",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: true,
          internalType: "address",
          name: "account",
          type: "address",
        },
        {
          indexed: true,
          internalType: "address",
          name: "operator",
          type: "address",
        },
        {
          indexed: false,
          internalType: "bool",
          name: "approved",
          type: "bool",
        },
      ],
      name: "ApprovalForAll",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: true,
          internalType: "address",
          name: "operator",
          type: "address",
        },
        {
          indexed: true,
          internalType: "address",
          name: "from",
          type: "address",
        },
        { indexed: true, internalType: "address", name: "to", type: "address" },
        {
          indexed: false,
          internalType: "uint256[]",
          name: "ids",
          type: "uint256[]",
        },
        {
          indexed: false,
          internalType: "uint256[]",
          name: "values",
          type: "uint256[]",
        },
      ],
      name: "TransferBatch",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: true,
          internalType: "address",
          name: "operator",
          type: "address",
        },
        {
          indexed: true,
          internalType: "address",
          name: "from",
          type: "address",
        },
        { indexed: true, internalType: "address", name: "to", type: "address" },
        {
          indexed: false,
          internalType: "uint256",
          name: "id",
          type: "uint256",
        },
        {
          indexed: false,
          internalType: "uint256",
          name: "value",
          type: "uint256",
        },
      ],
      name: "TransferSingle",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "string",
          name: "value",
          type: "string",
        },
        { indexed: true, internalType: "uint256", name: "id", type: "uint256" },
      ],
      name: "URI",
      type: "event",
    },
    {
      anonymous: false,
      inputs: [
        {
          indexed: false,
          internalType: "uint256",
          name: "tier",
          type: "uint256",
        },
        {
          indexed: false,
          internalType: "uint256",
          name: "sold",
          type: "uint256",
        },
      ],
      name: "updateSales",
      type: "event",
    },
    {
      inputs: [],
      name: "allMove",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [],
      name: "allSaleEnd",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        { internalType: "address", name: "", type: "address" },
        { internalType: "uint256", name: "", type: "uint256" },
      ],
      name: "balance",
      outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        { internalType: "address", name: "account", type: "address" },
        { internalType: "uint256", name: "id", type: "uint256" },
      ],
      name: "balanceOf",
      outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        { internalType: "address[]", name: "accounts", type: "address[]" },
        { internalType: "uint256[]", name: "ids", type: "uint256[]" },
      ],
      name: "balanceOfBatch",
      outputs: [{ internalType: "uint256[]", name: "", type: "uint256[]" }],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        { internalType: "uint256", name: "tier", type: "uint256" },
        { internalType: "uint256", name: "amount", type: "uint256" },
      ],
      name: "buyToken",
      outputs: [],
      stateMutability: "payable",
      type: "function",
    },
    {
      inputs: [{ internalType: "address", name: "", type: "address" }],
      name: "buyerId",
      outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "halfMove",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        { internalType: "address", name: "", type: "address" },
        { internalType: "uint256", name: "", type: "uint256" },
      ],
      name: "icoBalance",
      outputs: [{ internalType: "uint256", name: "", type: "uint256" }],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        { internalType: "address", name: "account", type: "address" },
        { internalType: "address", name: "operator", type: "address" },
      ],
      name: "isApprovedForAll",
      outputs: [{ internalType: "bool", name: "", type: "bool" }],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [
        { internalType: "address", name: "from", type: "address" },
        { internalType: "address", name: "to", type: "address" },
        { internalType: "uint256[]", name: "ids", type: "uint256[]" },
        { internalType: "uint256[]", name: "values", type: "uint256[]" },
        { internalType: "bytes", name: "data", type: "bytes" },
      ],
      name: "safeBatchTransferFrom",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        { internalType: "address", name: "from", type: "address" },
        { internalType: "address", name: "to", type: "address" },
        { internalType: "uint256", name: "id", type: "uint256" },
        { internalType: "uint256", name: "value", type: "uint256" },
        { internalType: "bytes", name: "data", type: "bytes" },
      ],
      name: "safeTransferFrom",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [{ internalType: "uint256", name: "tier", type: "uint256" }],
      name: "saleEnd",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        { internalType: "uint256", name: "tier", type: "uint256" },
        { internalType: "uint256", name: "amount", type: "uint256" },
      ],
      name: "saleOn",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [
        { internalType: "address", name: "operator", type: "address" },
        { internalType: "bool", name: "approved", type: "bool" },
      ],
      name: "setApprovalForAll",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [{ internalType: "bytes4", name: "interfaceId", type: "bytes4" }],
      name: "supportsInterface",
      outputs: [{ internalType: "bool", name: "", type: "bool" }],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [],
      name: "update",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
    {
      inputs: [{ internalType: "uint256", name: "", type: "uint256" }],
      name: "uri",
      outputs: [{ internalType: "string", name: "", type: "string" }],
      stateMutability: "view",
      type: "function",
    },
    {
      inputs: [{ internalType: "uint256", name: "amount", type: "uint256" }],
      name: "withdraw",
      outputs: [],
      stateMutability: "nonpayable",
      type: "function",
    },
  ],
];
var contract = new web3.eth.Contract(abi, c_addr);
var startBlock = 0;

async function getStartBlock() {
  startBlock = await contract.methods.startBlock().call();
  console.log("ICO start block: ", startBlock);
}

var subscription = await web3.eth.subscribe("newHeads");
subscription.on("data", async (blockhead) => {
  if (startBlock === 0) {
    await getStartBlock();
  }
  var currentBlock = blockhead.number;
  console.log(`Current Block: ${currentBlock}`);
  var interval = 10;
  var endBlock = startBlock + 50;
  var halfMoveBlock = startBlock + 75;
  var allMoveBlock = startBlock + 100;

  if (currentBlock < endBlock && (currentBlock - startBlock) % interval === 0) {
    await contract.methods.update().send({ from: account.address });
  }
  if (currentBlock >= endBlock) {
    await contract.methods.allSaleEnd().send({ from: account.address });
  }
  if (currentBlock === halfMoveBlock) {
    await contract.methods.halfMove().send({ from: account.address });
  }
  if (currentBlock === allMoveBlock) {
    await contract.methods.allMove().send({ from: account.address });
  }
});
