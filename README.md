<a name="readme-top"></a>

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/PeterMcQuaid/ERC20Yul/images">
    <img src="https://github.com/PeterMcQuaid/ERC20Yul/blob/main/images/logo.jpg" alt="Logo">
  </a>

  <h3 align="center">ERC20Yul</h3>

  <p align="center">
    ERC20Yul: A sleek and efficient ERC20-compliant token written in pure Yul 
    <br />
    <a href="https://github.com/PeterMcQuaid/ERC20Yul#compilation"><strong>Compilation »</strong></a>
    <br />
    <br />
    <a href="https://github.com/PeterMcQuaid/ERC20Yul#contributions">Contribute to ERC20Yul</a>
    ·
    <a href="https://github.com/PeterMcQuaid/ERC20Yul/issues">Report Bug</a>
    ·
    <a href="https://github.com/PeterMcQuaid/ERC20Yul/issues">Request Feature</a>
  </p>
</div>


## Table of Contents

- [Introduction](#introduction)
- [Compilation](#compilation)
- [Legal Disclaimer](#legal-disclaimer)
- [Contributions](#contributions)
- [License](#license)

## Introduction

ERC20Yul is an [ERC20](https://eips.ethereum.org/EIPS/eip-20) compliant token written in pure Yul. This allows for a more optimized and efficient token, where the individual bytes in each action can be controlled for. Ultimately this provides a sleek and gas-minimized UX.

## Compilation
    
Run the following shell command to compile:
```
solc --strict-assembly ERC20Yul.sol --bin
```

## Legal Disclaimer
  
Please note that ERC20Yul is intended for educational and demonstration purposes. The author is not responsible for any loss of funds or other damages caused by the use of project or its contracts. Always ensure you have backups of your keys and use this software at your own risk
  
## Contributions

Pull requests are welcome! Please ensure that any changes or additions you make are well-documented and covered by test cases.

For any bugs or issues, please open an [issue](https://github.com/PeterMcQuaid/ERC20Yul/issues).


## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details