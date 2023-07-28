include app.env

deploy_mytoken_local:
	forge build
	forge create --rpc-url ${LOCAL_RPC_URL} \
		--constructor-args ${distributor} \
		--private-key ${PRIVATE_KEY} \
		src/token/MyToken.sol:MyToken

deploy_mygovernor_local:
	forge build
	forge create --rpc-url ${LOCAL_RPC_URL} \
		--constructor-args ${token_addr} \
		--private-key ${PRIVATE_KEY} \
		src/governance/MyGovernor.sol:MyGovernor

.PHONY: deploy_local
