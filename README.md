# Bcoin::Client

[![Build Status](https://travis-ci.org/DanKnox-BitFS/bcoin-client.svg?branch=master)](https://travis-ci.org/DanKnox-BitFS/bcoin-client) [![Gem Version](https://badge.fury.io/rb/bcoin-client.svg)](https://badge.fury.io/rb/bcoin-client)

Ruby client for the [bcoin.io](http://bcoin.io) bitcoin node. This
client implements the HTTP wallet API methods. Perhaps one day I will
add a consumer for the WebSocket wallet events API.

This gem is developed and maintained by Dan Knox <dk@bitfs.us>.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bcoin-client'
```

And then execute:

$ bundle

Or install it yourself as:

$ gem install bcoin-client

## Usage

```bash
$ console
```

Initialize the client with your API key:

```ruby
pry> client = Bcoin::Client.new password: 'bcoin-ruby'
=> #<Bcoin::Client:0x007f85161b74c8 @options={:password=>"bcoin-ruby"}>
```

Retrieve the full list of wallets or skip to ahead to learn how to find a
single wallet.
Refreshing the full list performs a GET for each individual
wallet so don't do this if you have a ton of wallets.

```ruby
pry> client.wallets.refresh!
=> #<Bcoin::Client::Wallets @collection=[...]>
```

Lets find a wallet by id.

```ruby
# You can also pass the :token parameter if wallet auth is on.
pry> wallet = client.wallets.find id: 'primary'
=> #<Bcoin::Client::Wallet @attributes={
  :network=>"main",
  :wid=>1,
  :id=>"primary",
  :initialized=>true,
  :watchOnly=>false,
  :accountDepth=>1,
  :token=>"87499ed1df632246b3a3b98222668b030d5b9ed3617833f9ec08683af20c0dfb",
  :tokenDepth=>0,
  :state=>{
    "tx"=>0,
    "coin"=>0,
    "unconfirmed"=>0,
    "confirmed"=>0
  },
  :master=>{
    "encrypted"=>false
  },
  :account=>{
    "name"=>"default",
    "initialized"=>true,
    "witness"=>false,
    "watchOnly"=>false,
    "type"=>"pubkeyhash",
    "m"=>1, "n"=>1,
    "accountIndex"=>0,
    "receiveDepth"=>1,
    "changeDepth"=>1,
    "nestedDepth"=>0,
    "lookahead"=>10,
    "receiveAddress"=>"14Uk3qcs8RNxeprNunzNbunFXn6AbWHJBF",
    "nestedAddress"=>nil,
    "changeAddress"=>"1n5KTQbqcwcpuLfw47YFQwmyyM5Lgmbcd",
    "accountKey"=>"xpub6CuW3mzkvLHFZtNPGs3xN8tJCF8AighD7RjtPqTS6dwQay8iMqFguQuYC6cHXKYeBTM5qEofMDJ3CsgXwr59Se2HeBS3PoYYtRVySbaMvVX",
    "keys"=>[]
  }
}>
```

Now we can retrieve this wallet's master key.

```ruby
pry> wallet.master
=> #<Bcoin::Client::Master @attributes={
  :encrypted=>false,
  :key=>{
    "xprivkey"=>"xprv9s21ZrQH143K3VfDtnoq7BMDhh8JGwytkEfztoXfgoJUgLsWAisFTtZssbhh41JEN7BWtuLQeWdRyn4tQo4Wcc5xQYkoZNZ42RLCHUErCrN"},
    :mnemonic=>{
      "bits"=>128,
      "language"=>"english",
      "entropy"=>"46df98f5245d73bd707694d8b3b666d8",
      "phrase"=>"egg wolf diary emerge strong team scrub spoon suffer oval often ramp",
      "passphrase"=>""
    }
  }
}>
```

Create a new wallet:

```ruby
pry> wallet = client.wallets.create id: 'dan', type: :pubkeyhash
=> #<Bcoin::Client::Wallet @attributes={
  :network=>"main",
  :wid=>2,
  :id=>"dan",
  :initialized=>true, :watchOnly=>false, :accountDepth=>1,
  :token=>"1b7e6fb0a94e3432cafe6fbe58c057ac2d6c0048650769c45ecd551eb39ba003",
  :tokenDepth=>0,
  :state=>{
    "tx"=>0, "coin"=>0,
    "unconfirmed"=>0,
    "confirmed"=>0
  },
  :master=>{"encrypted"=>false},
  :account=>{
    "name"=>"default",
    "initialized"=>true,
    "witness"=>false,
    "watchOnly"=>false,
    "type"=>"pubkeyhash",
    "m"=>1, "n"=>1,
    "accountIndex"=>0, "receiveDepth"=>1, "changeDepth"=>1,
    "nestedDepth"=>0, "lookahead"=>10,
    "receiveAddress"=>"1LYEVNtioaiVkkhpJgPA4m5hAitpXFSeNc",
    "nestedAddress"=>nil,
    "changeAddress"=>"1N17f1HExuPvcyB4cUZcRPGmHHCSN7J9Uf",
    "accountKey"=>"xpub6DPi9Arcao3wG8oBBuGH4okiCQhifqwgZ86jnJJioqjeShe7MMhqE4Ykfe2YmBzD3Kto7vrszH9scYxGGShTJWjkCQfPWYH5rCDtaLJvqRv",
    "keys"=>[]
  }
}>
```

When the wallet is created without a passphrase, it's master key should be
unencrypted when retrieved.

```ruby
pry> wallet.master
=> #<Bcoin::Client::Master @attributes={
  :encrypted=>false,
  :key=>{
    "xprivkey"=>"xprv9s21ZrQH143K4VDn4ZZH9b1u3vbDGFesKy6g8uLqjsmwUiLwcsNusyHDzeVjQgdBfwNPfL5Fjgk13WNkuFL68LskGbDGn29nwcgYhZwviWc"},
    :mnemonic=>{
      "bits"=>128,
      "language"=>"english",
      "entropy"=>"09f479f97e705138b78233880985b4da",
      "phrase"=>"antique phrase layer woman agree ordinary task edit marine equip honey relax",
      "passphrase"=>""
    }
  }
}>
```

Lets go ahead and set a passphrase on this wallet.

```ruby
pry> wallet.passphrase new: 'testpass'
=> true
```

Now lets lock the wallet master key.

```ruby
pry> wallet.lock
=> true
```

With the wallet locked, the master key will now be returned encrypted.

```ruby
pry> wallet.master.refresh!
#<Bcoin::Client::Master @attributes={
  :encrypted=>true,
  :until=>0,
  :iv=>"ac51c8e4c2251ca0e3a8d32f282fa829",
  :ciphertext=>"4ce1c061359564c1e0e47e500cf44cb7271880129e86c03adec0986b85b714dbd5983afc4a77b93dd068f275bacc5b8493b454aee3ffbf2ccd40b527bd8176fa9ce5ae1d41e153d15ed18081478610d55e1470cc8d2267c88a82e5eb5af5af6e94178fd7f9efeb2aa334e7893c7e1094342d471c157873a80a99a0831b417847ccbafa16aa59d75cf79f487508687092002f2c15a682163cb6173d907ff4a6036958e3fb3604a035527ea4c5b4d2c6965dd275e42d3e2f7406c1f7621bcf4619",
  :algorithm=>"pbkdf2",
  :N=>50000,
  :r=>0,
  :p=>0
}>
```

We can unlock the wallet for a number of seconds to perform sensitive operations.

```ruby
pry> wallet.unlock passphrase: 'testpass', timeout: 60
=> true
```

With the wallet unlocked, we can now retrieve the private key and plain text mnemonic.

```ruby
pry> wallet.master.refresh!
=> #<Bcoin::Client::Master @attributes={
  :encrypted=>false,
  :key=>{
    "xprivkey"=>"xprv9s21ZrQH143K4VDn4ZZH9b1u3vbDGFesKy6g8uLqjsmwUiLwcsNusyHDzeVjQgdBfwNPfL5Fjgk13WNkuFL68LskGbDGn29nwcgYhZwviWc"},
    :mnemonic=>{
      "bits"=>128,
      "language"=>"english",
      "entropy"=>"09f479f97e705138b78233880985b4da",
      "phrase"=>"antique phrase layer woman agree ordinary task edit marine equip honey relax",
      "passphrase"=>""
    }
  }>
```

Finally, lets go ahead and send a transaction.

```ruby
pry> wallet.send rate: 0.0003, outputs: [{value: 1.5, address: '1LYEVNtioaiVkkhpJgPA4m5hAitpXFSeNc'}]
=> {
  {
    "wid": 2,
    "id": "dan",
    "hash": "d9c7526b00f6d563200f685e6e229f0b41982153502467497153f7f466bd46d2",
    "height": -1,
    "block": null,
    "ts": 0,
    "ps": 1502837803,
    "date": "2017-08-15T22:56:43Z",
    "index": -1,
    "size": 225,
    "virtualSize": 225,
    "fee": 4540,
    "rate": 20177,
    "confirmations": 0,
    "inputs": [
      {
        "value": 5000000000,
        "address": "RMKoN2RDoNMCvGKx2xigLezsDHBVV2WQ77",
        "path": {
          "name": "default",
          "account": 0,
          "change": false,
          "derivation": "m/0'/0/0"
        }
      }
    ],
    "outputs": [
      {
        "value": 500000000,
        "address": "RW6vfe34Qz3d6SmS3cnnQ2VyhQr6whWxpa",
        "path": null
      },
      {
        "value": 4499995460,
        "address": "RWFa7WXvhnc6GWeFhDUHAR38CYarWaMw9S",
        "path": {
          "name": "default",
          "account": 0,
          "change": true,
          "derivation": "m/0'/1/0"
        }
      }
    ],
    "tx": "0100000001659a478b1eb89bc5df48cd3a641d7996a644e2b05138a5e85c6483b9add9d4b0000000006a4730440220787987deb06a23e03b969abe8a95489aea604c1f5ff38657c40ced41b80b166102204d84297cf720344fa4f2119b8bd43b206b811a0fd535c24dcc80140eab0d0788012102354eb584896a4a2aea9729d0eff420f73193b8de6c55bdf6e6857cfede22ffbcffffffff020065cd1d000000001976a914e4699de8892b8623e1f87700fabc53470f698adc88ac447b380c010000001976a914e60c33f1d0c47fe550c33de373f0af79a58e788988ac00000000"
  }>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DanKnox/bcoin-client. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Bcoin::Client project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/DanKnox/bcoin-client/blob/master/CODE_OF_CONDUCT.md).
