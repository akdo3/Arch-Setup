# Languages

## Python
```bash
yay -S python --needed
```

### Python For Jupyter
```bash
yay -S python-ipykernel --needed
```

### Install Libraries

#### AI Libraries
```bash
yay -S python-pandas python-numpy python-seaborn python-matplotlib python-scikit-learn --needed
```

### Optional Packages
```
yay python-pandas-stubs  --needed
```
`python-pandas-stubs` To Show Expected Errors In Pandas.

## Rust

### Installation
```bash
yay -S rustup --needed
```

###  Compile
```bash
cargo build --release
cp target/release/prayer_rust ~/.config/waybar/scripts/prayer
```
