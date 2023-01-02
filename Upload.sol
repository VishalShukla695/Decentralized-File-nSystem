// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 < 0.9.0;

contract Upload {
     // here we give access to another user 
    struct Access{
        address user ;  //here we store another user address to share my data 
        bool access ;  // true or false

    }       
    mapping(address =>string[])value;
    mapping(address=>mapping(address=>bool)) ownership;
    mapping(address=>Access[])accessList;
    mapping(address=>mapping(address=>bool))previousData;
    function add(address _user,string memory url)external {
        value[_user].push(url);
    }
    function allow(address user ) external {
        ownership[msg.sender][user]=true; //here i give the access of this user
        if(previousData[msg.sender][user]){
            for(uint i=0;i<accessList[msg.sender].length;i++){
                if(accessList[msg.sender][i].user==user){
                 accessList[msg.sender][i].access=true;
                }

            }
        }
        accessList[msg.sender].push(Access(user,true)); //here we add address in our list
    }
    function disallow(address user)public{
        ownership[msg.sender][user]=false; //here we disallow particular address
        for(uint i=0;i<accessList[msg.sender].length;i++){ //to check all adress and play with condition and disallow
            if(accessList[msg.sender][i].user==user) {
                accessList[msg.sender][i].access=false;
            }
        } 
    }
    function display(address _user) external view returns(string[] memory){    // display function of value
        require(_user==msg.sender || ownership[_user][msg.sender],"You don't have access");
        return value[_user];
    }
    function shareAccess() public view returns (Access[] memory ){  //share list fetching
        return accessList[msg.sender];
    }
}