HedgieGame Smart Contracts

1.	Information
	-	Token: Hedgie (HDG)

	-	Attributes
		Color, Fire, Water, Air, Earth

	-	Methods
		* transferOwnership: change the owner of contract
		* totalSupply: returns initial total supply
		* balanceOf: returns balance of specified address
		* ownerOf: returns token owner from token ID
		* approve: approve token based on token ID so that specified address owner can take it sooner or later
		* approveMultple: approve multiple tokens based on token ID array.
		* takeOwnership: change the ownership of the token based on token ID
		* transfer: transfer token
		* transferMultiple: transfer multiple tokens
		* transferFrom: transfer token from "from" to "to" address
		* transferFromMultiple: transfer multiples tokens from "from" to "to" address
		* tokenOfOwnerByIndex: return tokens by index
		* getTokenAttributes: return token attributes data by token ID
		* getTokenColor: return color by token ID
		* createToken: create new token
		* tokenIdFromColor: get token id from its color
		* addTokenMetadata: add token meta data by tokenID
	-	Events
		* Transfer
		* Approval

2.	Installation
	-	Network (Dev)
		geth --datadir devnet --dev --fast --nodiscover --rpc --rpcaddr="localhost" --networkid 1337 console
	-	Network (Ropsten)
	-	Network (Live)

3.	Gas Cost
	-	Hedgie: 1745673
	-	Curio: 1130499
	-	HCC: 1130499