# Dotfiles

Personal macOS setup and configuration files managed with Ansible.

## Installation

```bash
./install.sh
```

This will:
1. Install Xcode Command Line Tools
2. Install Homebrew
3. Install Ansible
4. Run the configuration playbooks


## SSH Key Setup for GitHub

Generate a new SSH key for GitHub:

```bash
ssh-keygen -t ed25519 -C "eddy@fortick.io"
```

When prompted:
- Press Enter to accept the default file location (`~/.ssh/id_ed25519`)
- Enter a passphrase (recommended) or press Enter for no passphrase

Start the SSH agent and add your key:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

Copy the public key to your clipboard:

```bash
pbcopy < ~/.ssh/id_ed25519.pub
```

Then add the key to GitHub:
1. Go to [GitHub SSH Settings](https://github.com/settings/keys)
2. Click "New SSH key"
3. Paste your key and save

Test the connection:

```bash
ssh -T git@github.com
```

## Post-Install: Apps Requiring Sign-in

After running `install.sh`, install the Mac App Store apps and other apps requiring authentication:

```bash
brew bundle --file=configs/Brewfile.mas
```

This includes:
- Mac App Store apps (requires App Store sign-in)
- Google Drive
- NordVPN