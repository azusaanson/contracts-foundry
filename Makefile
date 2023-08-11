include app.env

deploy_mytoken_local:
	forge build
	forge create --rpc-url ${LOCAL_RPC_URL} \
		--private-key ${LOCAL_PRIVATE_KEY} \
		src/token/MyToken.sol:MyToken

deploy_mygovernor_local:
	forge build
	forge create --rpc-url ${LOCAL_RPC_URL} \
		--constructor-args ${token_addr} \
		--private-key ${LOCAL_PRIVATE_KEY} \
		src/governance/MyGovernor.sol:MyGovernor

gen_abi:
	solc --abi src/token/MyToken.sol -o abi/MyToken
	solc --abi src/governance/MyGovernor.sol -o abi/MyGovernor

.PHONY: deploy_mytoken_local deploy_mygovernor_local gen_abi
