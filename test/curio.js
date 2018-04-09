var Curio = artifacts.require("Curio");

contract('curio', function(accounts) {
  it("should assert true", function(done) {
    var curio = Curio.deployed();
    assert.isTrue(true);
    done();
  });

  it("should return the balance of token owner", function() {
  	var curio;
  	return Curio.deployed().then(function(instance){
  		curio = instance;
  		return curio.balanceOf.call(accounts[0]);
  	}).then(function(result){
  		assert.equal(result.toNumber(), 1000000000000000000000, 'balance is wrong');
  	})
  });

  it("should return total Supply", function() {
    var curio;
    return Curio.deployed().then(function(instance){
      curio = instance;
      return curio.totalSupply.call();
    }).then(function(result){
      assert.equal(result.toNumber(), 1000000000000000000000, 'total Supply is wrong');
    })
  });

  it("should transfer 100 tokens from A to B", function() {
    var curio;
    return Curio.deployed().then(function(instance){
      curio = instance;
      return curio.transfer(accounts[1], 100 * (10 ** 18));
    }).then(function(){
      return curio.balanceOf.call(accounts[0]);
    }).then(function(result){
      assert.equal(result.toNumber(), 900 * (10**18), 'A balance is wrong');
      return curio.balanceOf.call(accounts[1]);
    }).then(function(result){
      assert.equal(result.toNumber(), 100 * (10**18), 'B balance is wrong');
    });
  });

  it("should give C authority to spend A's tokens", function() {
    var curio;
    return Curio.deployed().then(function(instance){
      curio = instance;
      return curio.approve(accounts[2], 100 * (10**18));
    }).then(function(){
      return curio.increaseApproval(accounts[2], 100 * (10**18));
    }).then(function(){
      return curio.decreaseApproval(accounts[2], 50 * (10**18));
    }).then(function(){
      return curio.allowance.call(accounts[0], accounts[2]);
    }).then(function(result){
      assert.equal(result.toNumber(), 150 * (10**18), 'allowance value is wrong');
      return curio.transferFrom(accounts[0], accounts[1], 150 * (10**18), {from: accounts[2]});
    }).then(function(){
      return curio.balanceOf.call(accounts[0]);
    }).then(function(result){
      assert.equal(result.toNumber(), 750 * (10**18), 'A balance is wrong');
      return curio.balanceOf.call(accounts[1]);
    }).then(function(result){
      assert.equal(result.toNumber(), 250 * (10**18), 'B balance is wrong');
    });
  });
});