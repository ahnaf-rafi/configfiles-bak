CWD = $(shell pwd -P)

link:
	@echo "Removing ~/.config/nvim_old if it exists"
	@if [ -e ~/.config/nvim_old ]; then rm -rf ~/.config/nvim_old; fi;
	@echo "Backing up ~/.config/nvim to ~/.config/nvim_old if it exists"
	@if [ -e ~/.config/nvim ]; then mv ~/.config/nvim ~/.config/nvim_old; fi;
	@ln -sf $(CWD) ~/.config/nvim
	@echo "Created symlink to $(CWD) nvim config in ~/.config/nvim."

.PHONY: clean-local

clean-local:
	@rm -rf ~/.local/share/nvim
	@echo "Removed ~/.local/share/nvim"
	@rm -rf ~/.local/state/nvim
	@echo "Removed ~/.local/state/nvim"
