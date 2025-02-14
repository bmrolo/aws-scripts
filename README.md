## Installation: 
```sh
curl -s https://raw.githubusercontent.com/bmrolo/aws-scripts/main/install.sh | bash -s -- -f desired-file.sh
```
Note: Change the `desired-file` to the file that you would like to convert to a binary

##### Uninstallation
To uninstall a binary, run `sudo rm -rf /usr/local/bin/binary`

Example: `sudo rm -rf /usr/local/bin/ec2-start`

## Dependencies
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) - Used to interact with AWS services. Install instructions are found in documentation 
- [fzf](https://github.com/junegunn/fzf?tab=readme-ov-file#using-homebrew) - Used to quickly select directories - `brew install fzf`
- [jq](https://github.com/jqlang/jq) - Used to parse JSON output from awscli - `brew install jq`

## Usage:
To use any of the scripts, simply call them by type the name of the binary!
