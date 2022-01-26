pragma solidity >=0.7.0 <0.9.0;

contract PikeCoin{
    string NAME = "PikeCoin";
    string SYMBOL = "PiKA";

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint)) allowances; 

    address deployer;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor(){
        deployer = msg.sender; 
        balances[deployer] = 10000000 * 1e8;
    }

    function name() public view returns (string memory){
        return NAME;
    }
    
    function symbol() public view returns (string memory) {
        return SYMBOL;
    }
    
    function decimals() public view returns (uint8) {
        return 8;
    }
    
    function totalSupply() public view returns (uint256) {
        return 100000000 * 1e8; //100 million. 1e8 because decimals is 8 
    }
     

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        assert(balances[msg.sender] > _value);
        balances[msg.sender] = balances[msg.sender] - _value;
        balances[_to] =  balances[_to] + _value;

        emit Transfer(msg.sender, _to, _value);

        return true; 
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        if(balances[_from]< _value)
            return false; 
        if(allowances[_from][msg.sender]< _value)
            return false; 

        balances[_from] -= _value;
        balances[_to] += _value; 
        allowances[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        return true; 
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        //if(balances[msg.sender] < _value)
        //    return false;

        allowances[msg.sender][_spender] = _value; 
        emit Approval(msg.sender,_spender,_value);
        return true; 
    }
    
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances[_owner][_spender]; 
    }
    
    mapping(uint => bool) blockMined; 
    uint totalMinted = 10000000 * 1e8; //10 million were minted to deployer in constructor()

    function mine() public returns(bool success){
        if(blockMined[block.number]){
            return false; 
        }
        if(block.number%10 != 0){
            return false;
        }


        balances[msg.sender] = balances[msg.sender] + 10*1e8;
        totalMinted = totalMinted + 10*1e8;
        blockMined[block.number] = true;
        
        return true;
    }

    function getCurrentBlock() public view returns(uint){
        return block.number;
    }

    function isMined(uint blockNumber) public view returns(bool){
        return blockMined[blockNumber];
    }
    
}
