## app.py

from flask import Flask, jsonify, request
from web3 import Web3
from solcx import compile_source
import json

# Constants
DEFAULT_HOST = '127.0.0.1'
DEFAULT_PORT = 8545
DEFAULT_FLASK_PORT = 5000

# Initialize Flask app
app = Flask(__name__)

# Initialize Web3
web3 = Web3(Web3.HTTPProvider(f'http://{DEFAULT_HOST}:{DEFAULT_PORT}'))

# Load contract ABI and address
with open('Vault.json') as f:
    vault_contract_data = json.load(f)
vault_abi = vault_contract_data['abi']
vault_address = Web3.toChecksumAddress(vault_contract_data['networks']['5777']['address'])

with open('Vesting.json') as f:
    vesting_contract_data = json.load(f)
vesting_abi = vesting_contract_data['abi']
vesting_address = Web3.toChecksumAddress(vesting_contract_data['networks']['5777']['address'])

# Initialize contract instances
vault_contract = web3.eth.contract(address=vault_address, abi=vault_abi)
vesting_contract = web3.eth.contract(address=vesting_address, abi=vesting_abi)

# Helper function to get account
def get_account():
    return web3.eth.accounts[0]

# API to deposit tokens into the vault
@app.route('/deposit', methods=['POST'])
def deposit():
    data = request.get_json()
    amount = data.get('amount', 0)
    account = get_account()

    tx_hash = vault_contract.functions.deposit(amount).transact({'from': account})
    web3.eth.wait_for_transaction_receipt(tx_hash)

    return jsonify({'status': 'success', 'transaction': tx_hash.hex()})

# API to withdraw tokens from the vault
@app.route('/withdraw', methods=['POST'])
def withdraw():
    data = request.get_json()
    amount = data.get('amount', 0)
    account = get_account()

    tx_hash = vault_contract.functions.withdraw(amount).transact({'from': account})
    web3.eth.wait_for_transaction_receipt(tx_hash)

    return jsonify({'status': 'success', 'transaction': tx_hash.hex()})

# API to get the balance of an account
@app.route('/balance', methods=['GET'])
def get_balance():
    account = request.args.get('account', get_account())
    balance = vault_contract.functions.getBalance(account).call()
    return jsonify({'balance': balance})

# API to get the vesting schedule of an account
@app.route('/vesting-schedule', methods=['GET'])
def get_vesting_schedule():
    account = request.args.get('account', get_account())
    vesting_schedule = vault_contract.functions.getVestingSchedule(account).call()
    return jsonify({
        'startTime': vesting_schedule[0],
        'cliff': vesting_schedule[1],
        'duration': vesting_schedule[2],
        'interval': vesting_schedule[3]
    })

# Run the Flask app
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=DEFAULT_FLASK_PORT)
