# Credible

Store credentials in your repository safely

## A Word of Caution

Using this library does not automatically make you more or less secure. It is your responsibility to safeguard your secrets and understand the features and limits of any tools you use, including this one.

## Security Overview

At its essence, `credible` provides a means to create and read a `credentials.encrypted.yml` file. To unlock the credentials file, credible takes your private RSA key (private_key) and decrypts a random AES-256 key assigned to you (intermediate_key). It then uses intermediate_key to decrypt a blob assigned to you into a common AES-256 key (common_key). It then uses common_key to decrypt `credentials.encrypted.yml`.

In pseudocode, credible basically does this:

    private_key = YAML::load_file('~/.credible/localhost.yml')['private']
    cred_file   = YAML::load_file('config/credentials.encrypted.yml')

    intermediate_key_encrypted = cred_file['acl']['alice']['intermediate']
    common_key_encrypted       = cred_file['acl']['alice']['common']

    intermediate_key = rsa_decrypt(private_key,      intermediate_key_encrypted)
    common_key       = aes_decrypt(intermediate_key, common_key_encrypted)
    credentials_str  = aes_decrypt(common_key,       cred_file['data'])
    credentials      = YAML::load(credentials_str)

The intermediate key is used to avoid [Coppersmith's Attack](http://en.wikipedia.org/wiki/Coppersmith's_Attack) by using a different intermediate key for each user of `credible`.

## Installation

Add this line to your application's Gemfile:

    gem 'credible'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install credible

## Usage

Credible expects to use `config/credentials.encrypted.yml`. If you would like to use a different file location, pull requests are welcome. =)

### Using it the first time

    $ credible init # creates $HOME/.credible/localhost.yml (if needed)
                    # and config/credentials.encrypted.yml

### Adding information to be encrypted

    $ credible set production PUSHER_SECRET
    Please enter production value for PUSHER_SECRET: <entered text will not be shown>

### Showing encrypted information

Credible will show only the first two and last two characters by default. This allows you to simply verify the whole value was entered, without the entire value being stored in your terminal's buffer:

    $ credible show production PUSHER_SECRET
    01...ef

To view the entire encrypted value, pass the `--long` flag (note: you shouldn't really ever need to do this):

    $ credible show --long production PUSHER_SECRET
    0123456789abcdef

To view the list of encrypted keys:

    $ credible list
    development:
      PUSHER_SECRET
      AWS_SECRET_KEY
    production:
      PUSHER_SECRET
      AWS_SECRET_KEY
    staging:
      PUSHER_SECRET
      AWS_SECRET_KEY

### Adding collaborators

Let's say Alice wants to collaborate with you on a project you've initialized with `credible`. She'll need to install the gem per the instructions above, then run:

    # on alice's machine
    $ credible keygen

This essentially does the same thing as `credible init` but without creating a `config/credentials.encrypted.yml` file.

Next, she issues the following command to save her public key:

    # on alice's machine
        $ credbile public > alice.yml

She then transfers the public key to you via a secure channel, and you issue:

    $ credible grant alice.yml

Once Alice receives the updated `config/credentials.encrypted.yml`, she will be able to decrypt it.

### Adding servers

Prior to looking for `~/.credible/localhost.yml`, `credible` will try to use `ENV['CREDIBLE_PRIVATE_KEY']` if it exists. In bash, you would populate the environment variable like this:

    export CREDIBLE_PRIVATE_KEY=$(credible private --yes-i-understand-the-security-risks)

Note that the `--yes-i-understand-the-security-risks` flag is required to output the private key. How you go about setting up this environment variable depends on your deployment mechanism.

### Accessing encrypted info in code

Assuming either `ENV['CREDIBLE_PRIVATE_KEY']` or `~/.credible/localhost.yml` is properly setup, you can access your info as follows:

    pusher_key = Credible[:production]['PUSHER_SECRET_KEY']

The first key is always a symbol while the second is always a string. This allows for a shortcut:

    pusher_key = Credible['PUSHER_SECRET_KEY']

where the first key is inferred from `ENV['RAILS_ENV'].try(:to_sym)`, then `ENV['RACK_ENV'].try(:to_sym)`, then `:default`.

Decryption will occur only once, as the decrypted values are memoized and stored in memory.

## Contributing

0. Read some cryptographic documentation like:
   * [RSA Algorithm](http://en.wikipedia.org/wiki/RSA_(algorithm%29)
   * [AES Algorithm](http://en.wikipedia.org/wiki/Advanced_Encryption_Standard)
   * [Key Encapsulation](http://en.wikipedia.org/wiki/Key_encapsulation)
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
