pragma solidity ^0.4.18;

import "./SafeMath.sol";
import "./ERC721.sol";

contract Hedgie is ERC721{
    using SafeMath for uint256;

    string public constant name = "Hedgie";
    string public constant symbol = "HDG";
    uint public constant decimals = 7;

    uint256 private _totalSupply = 0;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private tokenOwner;

    // Mapping from color to token ID
    mapping(string => uint256) private colorToToken; 

    // Mapping from token ID to approved address
    mapping (uint256 => address) private tokenApprovals;

    // Mapping from owner to list of owner token IDs
    mapping (address => uint256[]) private ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private ownedTokensIndex;

    // Owner address
    address public owner = msg.sender;

    struct TokenMetadata {
        string color;
        uint256 fire;
        uint256 earth;
        uint256 air;
        uint256 water;
        uint256 creationTimestamp;
    }

    // Mapping from token ID to token Meta Data
    mapping(uint256 => TokenMetadata) public tokenMetadata;

    // Mapping from token ID to its existence
    mapping(uint256 => uint256) public tokenMetadataExistence;

    modifier onlyOwnerOf(uint256 _tokenId) {
        require(ownerOf(_tokenId) == msg.sender);
        _;
    }

    modifier onlyOwner() {
        require (msg.sender == owner);
        _;
    }

    function() public payable {}

    function transferOwnership(address newOwner) public onlyOwner {
        require(owner != newOwner);

        OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    } 

    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }

    /**
     * @dev Gets the balance of the specified address
     * @param _owner address to query the balance of
     * @return uint256 representing the amount owned by the passed address
     */
    function balanceOf(address _owner) public view returns (uint256) {
        return ownedTokens[_owner].length;
    }

    function ownerOf(uint256 _tokenId) public view returns (address){
        address _owner = tokenOwner[_tokenId];
        require(_owner != address(0));
        return _owner;
    }  

    function implementsERC721() public view returns (bool _implementsERC721){
        return true;
    }

    function parseValue(uint256 _value) internal pure returns (uint256){
        require(_value >= 0);
        require(_value <= 100);

        return _value * (10 ** decimals);
    }

    /**
     * @dev Gets the approved address to take ownership of a given token ID
     * @param _tokenId uint256 ID of the token to query the approval of
     * @return address currently approved to take ownership of the given token ID
     */
    function approvedFor(uint256 _tokenId) public view returns (address) {
        return tokenApprovals[_tokenId];
    }

    /**
     * @dev Approves another address to claim for the ownership of the given token ID
     * @param _to address to be approved for the given token ID
     * @param _tokenId uint256 ID of the token to be approved
    */
    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId){
        require(msg.sender != _to);

        if (approvedFor(_tokenId) != 0 || _to != 0) {
            tokenApprovals[_tokenId] = _to;
            Approval(msg.sender, _to, _tokenId);
        }
    }

    function approveMultiple(address _to, uint256[] _tokenIds) public{
        require(msg.sender != _to);

        for (uint i = 0; i < _tokenIds.length; i++) {
            require(msg.sender == ownerOf(_tokenIds[i]));

            if (approvedFor(_tokenIds[i]) != 0 || _to != 0) {
                tokenApprovals[_tokenIds[i]] = _to;
                Approval(msg.sender, _to, _tokenIds[i]);
            }
        }
    }

    /**
     * @dev Internal function to clear current approval of a given token ID
     * @param _tokenId uint256 ID of the token to be transferred
     */
    function clearApproval(address _owner, uint256 _tokenId) private {
        require(ownerOf(_tokenId) == _owner);
        tokenApprovals[_tokenId] = 0;
        Approval(_owner, 0, _tokenId);
    }

    function createToken() public onlyOwner {
        uint256 _tokenId = totalSupply().add(1);

        addToken(msg.sender, _tokenId);
        Transfer(0x0, msg.sender, _tokenId);
    }

    /**
     * @dev Internal function to add a token ID to the list of a given address
     * @param _to address representing the new owner of the given token ID
     * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
     */
    function addToken(address _to, uint256 _tokenId) private {
        require(tokenOwner[_tokenId] == address(0));

        tokenOwner[_tokenId] = _to;
        uint256 length = balanceOf(_to);
        ownedTokens[_to].push(_tokenId);
        ownedTokensIndex[_tokenId] = length;

        _totalSupply++;
    }

    /**
     * @dev Internal function to remove a token ID from the list of a given address
     * @param _from address representing the previous owner of the given token ID
     * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function removeToken(address _from, uint256 _tokenId) private {
        require(ownerOf(_tokenId) == _from);

        uint256 tokenIndex = ownedTokensIndex[_tokenId];
        uint256 lastTokenIndex = balanceOf(_from).sub(1);
        uint256 lastToken = ownedTokens[_from][lastTokenIndex];

        /* Remove token from owner */
        tokenOwner[_tokenId] = address(0); // No owner for this token
        ownedTokens[_from][tokenIndex] = lastToken;
        ownedTokens[_from][lastTokenIndex] = 0;
        ownedTokens[_from].length--;

        ownedTokensIndex[_tokenId] = 0;
        ownedTokensIndex[lastToken] = tokenIndex;

        _totalSupply--;
    }

    /**
     * @dev Internal function to clear current approval and transfer the ownership of a given token ID
     * @param _from address which you want to send tokens from
     * @param _to address which you want to transfer the token to
     * @param _tokenId uint256 ID of the token to be transferred
     */
    function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0));
        require(_to != ownerOf(_tokenId));
        require(ownerOf(_tokenId) == _from);

        clearApproval(_from, _tokenId);
        removeToken(_from, _tokenId);
        addToken(_to, _tokenId);
        Transfer(_from, _to, _tokenId);
    }

    /**
     * @dev Claims the ownership of a given token ID
     * @param _tokenId uint256 ID of the token being claimed by the msg.sender
     */
    function takeOwnership(uint256 _tokenId) public{
        require(approvedFor(_tokenId) == msg.sender);
        clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        require(approvedFor(_tokenId) == msg.sender);
        require(ownerOf(_tokenId) == _from);
        require(_to != address(0));

        clearApprovalAndTransfer(_from, _to, _tokenId);
    }

    function transferFromMultiple(address _from, address _to, uint256[] _tokenIds) public {
        for (uint i = 0; i < _tokenIds.length; i++){
            require(approvedFor(_tokenIds[i]) == msg.sender);
            require(ownerOf(_tokenIds[i]) == _from);
            require(_to != address(0));

            clearApprovalAndTransfer(_from, _to, _tokenIds[i]);
        }
    }

    /**
     * @dev Transfers the ownership of a given token ID to another address
     * @param _to address to receive the ownership of the given token ID
     * @param _tokenId uint256 ID of the token to be transferred
     */
    function transfer(address _to, uint256 _tokenId) public {
        clearApprovalAndTransfer(msg.sender, _to, _tokenId);
    }

    function transferMultiple(address _to, uint256[] _tokenIds) public {
        for (uint i = 0; i < _tokenIds.length; i++){
            clearApprovalAndTransfer(msg.sender, _to, _tokenIds[i]);
        }
    }

    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId){
        return ownedTokens[_owner][_index];
    }

    function getTokenAttributes(uint256 _tokenId) public constant returns (uint256, uint256, uint256, uint256){
        return (tokenMetadata[_tokenId].fire, tokenMetadata[_tokenId].earth, tokenMetadata[_tokenId].air, tokenMetadata[_tokenId].water);
    }

    function getTokenColor(uint256 _tokenId) public constant returns (string){
        return tokenMetadata[_tokenId].color;
    }

    /**
     * @dev return token ID from color code
     */
    function tokenIdFromColor(string _color) public view returns (uint256 tokenId){
        return colorToToken[_color];
    }

    /**
     * @dev Add a token meta data
     */
    function addTokenMetadata(
        uint256 _tokenId,
        string _color, 
        uint256 _fire, 
        uint256 _earth, 
        uint256 _air, 
        uint256 _water
    ) public onlyOwner {
        require(ownerOf(_tokenId) != address(0)); // Token Exists
        require(tokenMetadataExistence[_tokenId] == 0); // New Token Metadata
        require(colorToToken[_color] == 0); // New Color

        _fire = parseValue(_fire);
        _earth = parseValue(_earth);
        _air = parseValue(_air);
        _water = parseValue(_water);

        tokenMetadata[_tokenId] = TokenMetadata(
            _color, _fire, _earth, _air, _water, now
        );

        tokenMetadataExistence[_tokenId] = 1;
        colorToToken[_color] = _tokenId;
    }
}