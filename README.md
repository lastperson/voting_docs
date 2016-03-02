
# Voting Registry

The registry bootstraps the System. It manages Community and Poll contracts. A registy contract is deployed at `0x335d44e65c592110289b9119006af96d0726cd65`

# Voting Community

Different communities can be set up. Their task to to KYC accounts of voters.

# Polls

Polls can be created by organizers. Beforhand, the organizer has to select one or many communities. The verified members of those communities will be allowed to cast a ballot in this poll.

#Reading Poll list and Poll details from Node.js

##Installing web 3
```
npm install web3
```

##initializing web 3
```javascript
var web3Provider = 'http://52.28.142.166:8545/';
var web3 = new Web3();
web3.setProvider(new web3.providers.HttpProvider(web3Provider));
```
 
##using registration contract to read a list of polls
```javascript
var fromBlock = 869624;
var regAddress = '0x335d44e65c592110289b9119006af96d0726cd65';
var regAbi = '[{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"owners","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"providers","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"provNames","outputs":[{"name":"","type":"string"}],"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"pollNames","outputs":[{"name":"","type":"string"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"polls","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"pollIndex","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"_poll","type":"address"},{"name":"_name","type":"string"}],"name":"addPoll","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"_provider","type":"address"}],"name":"remProvider","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"provIndex","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"_provider","type":"address"},{"name":"_name","type":"string"}],"name":"addProvider","outputs":[{"name":"","type":"bool"}],"type":"function"},{"inputs":[],"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"name":"provider","type":"address"}],"name":"Provider","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"poll","type":"address"}],"name":"Poll","type":"event"}]';
var regContract = web3.eth.contract($.parseJSON(regAbi)).at(regAddress);
regContract.allEvents({fromBlock: fromBlock, toBlock: 'latest'}, function(err,op) {
  if (op.event === 'Poll') {
    console.log('found poll at address: ' + op.args.poll);
    //read name of poll
    regContract.pollIndex(op.args.poll, function(error, index) {
      regContract.pollNames(index, function(error, name) {
        console.log('poll at address: ' + op.args.poll + 'is named ' + name);
      });
    });
  }
});
```

##using poll contract to read poll details
```javascript
var pollAddress = 'see section "using registration contract to read a list of polls"';
var pollAbi = '[{"constant":false,"inputs":[],"name":"count","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"idVers","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"index","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"_now","type":"uint256"}],"name":"countTimed","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[],"name":"questions","outputs":[{"name":"","type":"string"}],"type":"function"},{"constant":false,"inputs":[{"name":"_ballot","type":"uint8[]"},{"name":"_now","type":"uint256"}],"name":"castTimed","outputs":[{"name":"","type":"bytes32"}],"type":"function"},{"constant":false,"inputs":[{"name":"_start","type":"uint256"},{"name":"_end","type":"uint256"},{"name":"_answerCount","type":"uint8[]"},{"name":"_idVers","type":"address[]"},{"name":"_questions","type":"string"}],"name":"setParams","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"_ballot","type":"uint8[]"}],"name":"cast","outputs":[{"name":"","type":"bytes32"}],"type":"function"},{"constant":true,"inputs":[],"name":"start","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"name":"results","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"voters","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[],"name":"answersLength","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"answerCount","outputs":[{"name":"","type":"uint8"}],"type":"function"},{"constant":true,"inputs":[],"name":"end","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"},{"name":"","type":"uint256"}],"name":"ballots","outputs":[{"name":"","type":"uint8"}],"type":"function"},{"inputs":[],"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"voter","type":"address"},{"indexed":true,"name":"hash","type":"bytes32"}],"name":"Vote","type":"event"}]';
var pollContract = web3.eth.contract($.parseJSON(pollAbi)).at(pollAddress);
pollContract.start(function(error, startTime) {
  console.log('poll at address: ' + pollAddress + ' will start at ' + startTime);
});
pollContract.end(function(error, endTime) {
  console.log('poll at address: ' + pollAddress + ' will end at ' + endTime);
});
pollContract.answersLength(function(error, count) {
  console.log('poll at address: ' + pollAddress + ' has ' + count + 'questions.');
});
```

#Managing Community from Geth Console

## Binding to contract

```javascript
> var comm = web3.eth.contract([{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"members","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"_newOwner","type":"address"}],"name":"setOwner","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"address"}],"name":"index","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[{"name":"_member","type":"address"}],"name":"remMember","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"hashes","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"applicants","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"requests","outputs":[{"name":"","type":"bytes32"}],"type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"_member","type":"address"}],"name":"isMember","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"_applicant","type":"address"}],"name":"reject","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"_applicant","type":"address"}],"name":"addMember","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"_applicant","type":"address"},{"name":"_request","type":"bytes32"},{"name":"_hash","type":"uint256"}],"name":"request","outputs":[{"name":"","type":"bool"}],"type":"function"},{"inputs":[],"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"applicant","type":"address"},{"indexed":true,"name":"request","type":"bytes32"},{"indexed":false,"name":"hash","type":"uint256"}],"name":"Request","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"applicant","type":"address"}],"name":"Reject","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"applicant","type":"address"}],"name":"Accept","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"applicant","type":"address"}],"name":"Remove","type":"event"}]).at("0xa92cff3d614fd9dca7e873eaa6bbdd818b3fad3e");
undefined
> > comm.address
"0xa92cff3d614fd9dca7e873eaa6bbdd818b3fad3e"
```

## Setting Contract Owner

The Owner is the admin of the contract. Only the current owner can appoint a new owner.  The owner is the only one who can approve and reject member applications.

```javascript
> comm.setOwner.sendTransaction("0x00da0847592774280c84b106dce8d54c39b5b5f6",{from:eth.accounts[0], gas: 120000});
"0xb8a3f4b7a1537885f4bb1982c9b402901c675367a132df712baeca9bb2b9d2af"
> comm.owner()
"0x00da0847592774280c84b106dce8d54c39b5b5f6"
```

## Requesting Membership in Community

This call is unrestricted. Everyone can submit an application to it. The application consists of the account address, a URI to a JSON object holding application data, and a SHA-hash of the content of the application. 

```javascript
> comm.request.sendTransaction("0xe6b032b23bc145ed19e23792e2a107d0794fe65a","http://some.url/application.json","0x123567",{from:eth.accounts[0], gas: 150000});
"0x669b8c0dba902e7a727749278acc3e2c9c44b02af72885385745e26febd9188f"
```
This will trigger the `event Request(address indexed applicant, bytes32 indexed request, uint256 hash);` event on the contract. After an application is submitted the application data can be queried by address.

```javascript
> comm.index("0xe6b032b23bc145ed19e23792e2a107d0794fe65a");
1
> comm.requests(1);
"0x687474703a2f2f736f6d652e75726c2f6170706c69636174696f6e2e6a736f6e"
> comm.applicants(1);
"0xe6b032b23bc145ed19e23792e2a107d0794fe65a"
> comm.hashes(1);
1193319
```

## Managing Applications

Pending applications can be approved or rejected. Once accepted, accounts become Members. The Poll conract will call the `isMember(addr)` function when a ballot is casted. Any rejected account can apply again. Member accounts can also be removed and apply again.

### Rejecting Application

Any pending Application can be rejected and will be removed from contract storage. Once rejected account can apply again.

```javascript
> comm.reject.sendTransaction("0xe6b032b23bc145ed19e23792e2a107d0794fe65a",{from:eth.accounts[0], gas: 150000});
"0x6934bea5a2da7e44afbb0ad4f69ace60b38e0e45ca45e5d954024a28c19e0669"
> comm.index("0xe6b032b23bc145ed19e23792e2a107d0794fe65a");
0
```

This will trigger the `Reject(address indexed applicant);` event on the contract.

### Accepting Applications

Once an application is accepted its address is removed from the pending applications. 

```javascript
> comm.addMember.sendTransaction("0xe6b032b23bc145ed19e23792e2a107d0794fe65a",{from:eth.accounts[0], gas: 150000});
"0xac859e43fea980e65e469b0dafeceb510d572b8e0b20f83ef18f272a2e74d04f"
> comm.index("0xe6b032b23bc145ed19e23792e2a107d0794fe65a");
0
```
This will trigger the `Accept(address indexed applicant);` event on the contract.

The function will be called by the Poll contract when this accounts casts a ballot to it.
```javascript
> comm.isMember("0xe6b032b23bc145ed19e23792e2a107d0794fe65a");
true
```
### Removing Members

```javascript
> comm.remMember.sendTransaction("0xe6b032b23bc145ed19e23792e2a107d0794fe65a",{from:eth.accounts[0], gas: 150000});
"0xab0593239bb538c0822c0289d47f991ed5183b20d25666e73fba7cffaf385c6d"
```
This will trigger the `Remove(address indexed applicant);` event on the contract.


## Javascript functions

deploying a contract:

```javascript
var pollAbi = 'see above';
var pollBytes = '606060405260068054600160a060020a031916321790556008805460018101808355909190828015829011606557818360005260206000209182019101606591905b80821115609857600081556001016041565b50505050610d4c806100d06000396000f35b505060098054600181018083559093509091508280158290116053578183600052602060002091820191016053919060a2565b5090565b50506001015b808211156098576000818150805460008255601f016020900490600052602060002090810190609c9190604156606060405236156100b95760e060020a600035046306661abd81146100bb5780630e96b91d146100c957806318def8ef1461010f57806331329f111461012757806377a498211461017d5780638598db8b146101db5780638d9ede35146102e6578063976a3a4d146103d8578063be9a655514610429578063d70c6f4e14610432578063da58c7d91461048b578063de1b7b4f146104d1578063e73cf0da146104ea578063efbe1c1c14610525578063ff3aa4221461052e575b005b61059760006108b54261012e565b6105a960043560058054829081101561000257506000527f036b6384b5eca791c62761152d0c79bb0604c104a5fb6f4eb0703f3154bb3db00154600160a060020a031681565b61059760043560076020526000908152604090205481565b6105976004355b600060006000600160005054841015801561014a5750600a5481145b1561089f57600254600a8054828255829080158290116108bc578183600052602060002091820191016108bc9190610978565b6105c66003805460408051602060026001851615610100026000190190941693909304601f810184900484028201840190925281815292918301828280156106765780601f1061064b57610100808354040283529160200191610676565b6040805160048035808201356020818102858101820190965281855261059795939460249490938501929182919085019084908082843750949650509335935050505060006000600061068585855b6000600060006000846000600050541115801561024957506001548511155b801561025757506002548651145b15610b4d57600092505b600254831015610b5657600280548490811015610002576000919091526020808204600080516020610d2c8339815191520191069054906101000a900460ff1660ff1686848151811015610002579060200190602002015160ff1611156102da5760008684815181101561000257602090810290910101525b60019290920191610261565b6040805160443560048181013560208181028086018201909652818552610597958335956024803596606495929491019282918501908490808284375050604080519635808901356020818102808b018201909452818a529799986084989097506024929092019550935083925085019084908082843750506040805160209735808a0135601f81018a90048a0283018a0190935282825296989760a4979196506024919091019450909250829150840183828082843750949650505050505050600654600090600160a060020a03908116329091161415806103cb57506002548190115b1561068e57506000610685565b60408051600480358082013560208181028581018201909652818552610597959394602494909385019291829190850190849080828437509496505050505050506000600060006108ac844261022a565b61059760005481565b610597600435602435600a8054839081101561000257506000527fc65a7bb8d6351c1cf70c95a316cc6a92839c986682d98bc35f958f4883f9d2a882018054829081101561000257506000908152602090200154905081565b6105a960043560088054829081101561000257506000527ff3f7a9fe364faab93b216da50a3214154f22a0a2b415b23a84c8169e8b636ee30154600160a060020a031681565b6105976002546000908114156108975750600a5461089c565b61063460043560028054829081101561000257506000526020808204600080516020610d2c833981519152015491066101000a900460ff1681565b61059760015481565b61063460043560243560098054839081101561000257506000527f6e1540171b6c0c960b71a7020d9f60077f6af931a8bbf590da0223dacf75c7af82018054829081101561000257506000908152602090819020818304015491066101000a900460ff16905081565b60408051918252519081900360200190f35b60408051600160a060020a03929092168252519081900360200190f35b60405180806020018281038252838181518152602001915080519060200190808383829060006004602084601f0104600f02600301f150905090810190601f1680156106265780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b6040805160ff929092168252519081900360200190f35b820191906000526020600020905b81548152906001019060200180831161065957829003601f168201915b505050505081565b5050600190505b95945050505050565b8160036000509080519060200190828054600181600116156101000203166002900490600052602060002090601f016020900481019282601f106106f557805160ff19168380011785555b506107259291505b808211156107aa57600081556001016106e1565b828001600101855582156106d9579182015b828111156106d9578251826000505591602001919060010190610707565b50506000868155600186905584516002805482825592819052916020601f91909101819004600080516020610d2c8339815191529081019291880182156107b05791602002820160005b838211156107d057835183826101000a81548160ff02191690830217905550926020019260010160208160000104928301926001030261076f565b5090565b505b506107fd9291505b808211156107aa57805460ff191681556001016107b8565b80156107ae5782816101000a81549060ff02191690556001016020816000010492830192600103026107d0565b5050825160058054828255600082905290917f036b6384b5eca791c62761152d0c79bb0604c104a5fb6f4eb0703f3154bb3db091820191602087018215610871579160200282015b828111156108715782518254600160a060020a0319161782556020929092019160019190910190610845565b5061067e9291505b808211156107aa578054600160a060020a0319168155600101610879565b506002545b90565b600092505b50505b919050565b925050506108a7565b905061089c565b5050600254935050505b60008260ff16111561099d5760028054600019840190811015610002576000919091526020808204600080516020610d2c8339815191520191069054906101000a900460ff1660010160ff16600a6000506001840381548110156100025760009182527fc65a7bb8d6351c1cf70c95a316cc6a92839c986682d98bc35f958f4883f9d2a8019050818154818355818115116109b6576000838152602090206109b69181019083016106e1565b50506001015b808211156107aa578054600080835582815260208120909161097291908101906106e1565b60068054600160a060020a0319169055600192506108a4565b50505050600190505b600954811015610a8c57600a80546000198401908110156100025760009182527fc65a7bb8d6351c1cf70c95a316cc6a92839c986682d98bc35f958f4883f9d2a80190506009805483908110156100025760009182527f6e1540171b6c0c960b71a7020d9f60077f6af931a8bbf590da0223dacf75c7af0190506001840381548110156100025790600052602060002090602091828204019190069054906101000a900460ff168154811015610002579060005260206000209001600050805460010190556001016109bf565b600280546000198101808355909190828015829011610acc57601f016020900481601f01602090048360005260206000209182019101610acc91906106e1565b50505050600019909101906108c6565b50505032600160a060020a0316600081815260076020908152604080832085905560048054600181810190925582519087018a019091018152905190819003909101812092839290917fc1eff9d9e2ab8a2b29706e0c2818cd78972e60f1ce84c268a77005b0bece97c49190a38093505b50505092915050565b32600160a060020a03166000908152600760205260408120549250821415610bae576008805460018101808355909190828015829011610c8357818360005260206000209182019101610c8391906106e1565b505050505b32600860005083815481101561000257600091909152507ff3f7a9fe364faab93b216da50a3214154f22a0a2b415b23a84c8169e8b636ee383018054600160a060020a0319169091179055600980548791908490811015610002579060005260206000209001600050908051906020019082805482825590600052602060002090601f01602090048101928215610cf35791602002820160005b83821115610cff57835183826101000a81548160ff021916908302179055509260200192600101602081600001049283019260010302610c48565b5050600980546001810180835593955092909150828015829011610ba957818360005260206000209182019101610ba99190610cc0565b50506001015b808211156107aa576000818150805460008255601f016020900490600052602060002090810190610cba91906106e1565b505b50610adc9291506107b8565b8015610cf15782816101000a81549060ff0219169055600101602081600001049283019260010302610cff56405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace';
var Poll = web3.eth.contract(pollAbi));
var pollData = Poll.getData({data: pollBytes});
var tx = web3.eth.createTransaction('', 0, pollData);
web3.eth.sendTransaction(tx, function(error, transaction) {
  console.log('tx sent: ' + transaction.hash);
});

```

waiting for a tx to be mined from web3:

```javascript
web3.eth.sendTransaction(tx, function(e, a) {
  if (!e) {
    var filter = web3.eth.filter('latest');
    filter.watch(function (error, log) {
      web3.eth.getTransactionReceipt(tx, function(e, receipt){
        if (error || !receipt) {
          console.log('waiting...'); 
          return this;
        }
        filter.stopWatching();
        console.log('tx '+ receipt.hash + 'mined'); 
      });
    });
  }
});
```

after the new contract is created, the poll parameters need to be set on it:

```javascript
var start; //start time from when ballots can be cast
var end; //end time until ballots can be cast
var questionCount; //array of integer. length of array represents how many questions are in this poll. array cell determines how many different answers possible
var communities; //address of communities that will be checked for ballot castor identity
var questions; //json string of questions and answers
var setConfigIba = '';
var pollAddress = 'deployedPollAddress';
var fun = new SolidityFunction(setConfigIba, pollAddress);
var data = [start, end, questionCount, communities, questions];
var tx = web3.eth.createTransaction(receipt.contractAddress, 0, fun.toPayload(data).data);
web3.eth.sendTransaction(tx, function(error, transaction) {
  console.log('tx sent: ' + transaction.hash);
});
```
