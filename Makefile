include app.env

deploy_mytoken_local:
	forge build
	forge create --rpc-url ${LOCAL_RPC_URL} \
		--constructor-args ${LOCAL_GOVERNOR_ADDR} \
		--private-key ${LOCAL_PRIVATE_KEY} \
		src/token/MyToken.sol:MyToken

deploy_mygovernor_local:
	forge build
	forge create --rpc-url ${LOCAL_RPC_URL} \
		--constructor-args ${LOCAL_TOKEN_ADDR} \
		--private-key ${LOCAL_PRIVATE_KEY} \
		src/governance/MyGovernor.sol:MyGovernor

anvil_mine_block:
	curl -s -X POST  -H "Content-Type: application/json" \
		--data '{"jsonrpc":"2.0","method":"anvil_mine","params":[1],"id":1}' \
		 "localhost:8545"

anvil_mine_blocks_one_day:
	curl -s -X POST  -H "Content-Type: application/json" \
		--data '{"jsonrpc":"2.0","method":"anvil_mine","params":[7200],"id":1}' \
		 "localhost:8545"

gen_abi:
	solc --abi src/token/MyToken.sol -o abi/MyToken --overwrite
	solc --abi src/governance/MyGovernor.sol -o abi/MyGovernor --overwrite

.PHONY: deploy_mytoken_local deploy_mygovernor_local anvil_mine_block anvil_mine_blocks_one_day gen_abi
