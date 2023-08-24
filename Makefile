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

gen_abi:
	solc --abi src/token/MyToken.sol -o abi/MyToken --overwrite
	solc --abi src/governance/MyGovernor.sol -o abi/MyGovernor --overwrite

.PHONY: deploy_mytoken_local deploy_mygovernor_local gen_abi
