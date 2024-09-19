# WARNING

> Use this script at your own risk. The author assumes no responsibility for any outcomes resulting from the use of this script. By using this script, you accept full responsibility for any potential consequences.

# INSTALLATION

## zsh
The installation process depends on your OS. For example:

- Ubuntu/Debian: `sudo apt install zsh`
- macOS (with Homebrew): `brew install zsh`
To set Zsh as your default shell:

```bash
chsh -s $(which zsh)
```

For more detailed instructions, please refer to the [Zsh documentation](https://www.zsh.org/) or consult your OS-specific resources.

## bootstrap
The recommended **bootstrap.sh** directory is *~/configs/*.

```sh
mkdir ~/configs
cd ~/configs
git clone git@bitbucket.org:andreyu/bootstrap.git
./bootstrap.sh
```

Follow instructions.
