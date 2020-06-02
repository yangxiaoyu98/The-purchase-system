
pragma solidity ^0.4.22;

contract Purchase {
    uint public value;
    uint public warehouse=0;
    uint public storage=0;
    clock d;
    address public seller;
    address public buyer;
    enum State { paid,abort,delivered, confirmed }
    State public state;

    // Ensure that `msg.value` is an  even number.
    // Division will truncate if it is an odd number.
    // Check via multiplication that it wasn't an odd number.
    constructor() public payable {
        seller = msg.sender;
        value = msg.value / 2;
        require((2 * value) == msg.value, "Value has to be even.");
    }

    modifier condition(bool _condition) {
        require(_condition);
        _;
    }
    modifier enoughmoney(int account){
        require(account>=value);
        _;
    }
    modifier enoughgoods(int goods){
        require(goods>0);
        _;
    }
    modifier onlyBuyer() {
        require(
            msg.sender == buyer,
            "Only buyer can call this."
        );
        _;
    }

    modifier onlySeller() {
        require(
            msg.sender == seller,
            "Only seller can call this."
        );
        _;
    }

    modifier inState(State _state) {
        require(
            state == _state,
            "Invalid state."
        );
        _;
    }
    modifier isaborted(){
        require(d>7);
        _;
    }

    event Aborted();
    event PurchaseConfirmed();
    event ItemReceived();
    event Paided();

    /// Abort the purchase and reclaim the ether.
    /// Can only be called by the seller before
    /// the contract is locked.
    function afford()
        public
        condition
        enoughaccount
    {
        emit Paided();
        d=0
        seller.transfer(value);
        state = State.paid;
    }

    /// Confirm the purchase as buyer.
    /// Transaction has to include `2 * value` ether.
    /// The ether will be locked until confirmReceived
    /// is called.
    function wait()
        public
        onlybuyer()
        {
            if(isaborted){
                emit Aborted()
                state = aborted()
                buyer.transfor(value)
            }
        }

    function confirmReceived()
        public
        onlybuyer()
        inState(State.delivered)
        afford
    {
        if(state == State.abort){
            buyer.transfor(value)
        }
        else{
            state = State.confirmed
            goods += 1
        }
    }

    function idel()
        onlyseller()
        {
            if(goods==0){
                condition = false
            }
            state = State.paid
        }


    /// Confirm that you (the buyer) received the item.
    /// This will release the locked ether.
    function deliverConfirm()
        public
        onlyBuyer
        inState(State.delivered)
    {
        emit ItemReceived();
        if(state != State.abort){
            state = State.delivered
            account += value
        }

        buyer.transfer(value);
        seller.transfer(address(this).balance);
    }

    function wait()
        onlyseller()
        inState(State.delivered)
        {
            if(state == State.abort){
                buyer.transfor(value)
            }
            else{
                state = State.confirmed
                account += value
            }
        }
}











