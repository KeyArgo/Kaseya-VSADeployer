# VSADeployer v1.0

VSADeployer is an AutoHotkey utility script designed to manage, download, and install VSA software packages for different practices from a centralized location. The tool provides an intuitive graphical user interface to interact with the features it offers, making it an essential asset for administrators managing VSA deployments across multiple practices.

## Features

1. **Graphical User Interface (GUI)**
    
    * User-friendly interface with buttons, a ListView, and search functionality.
    * The ListView displays the practices and their corresponding package IDs loaded from a configuration file.
    * Real-time search results displayed in the ListView.
2. **Downloading & Installing Packages**
    
    * Select a practice from the ListView and download the corresponding VSA package.
    * The script ensures any previously installed VSA agent is uninstalled before installing the new package.
    * Progress updates are provided through message boxes.
3. **Generating Batch Files**
    
    * Generate a batch file for each practice, facilitating the download and installation of VSA packages.
    * The batch files are stored in a dedicated directory.
4. **Package Management**
    
    * Add new packages by specifying the practice name and package ID.
    * Delete selected packages directly from the GUI.
    * Changes are reflected in the configuration file, and the ListView is refreshed accordingly.
5. **Configuration Reload**
    
    * Reload the configuration from the INI file, refreshing the ListView with updated package information.
6. **Self-Destruct Feature**
    
    * The utility offers a self-destruct feature to remove itself and its configuration file, ensuring no residual files are left.

## Usage

1. **Run the script** - Execute the AutoHotkey script to start VSADeployer.
2. **Interact with the GUI** - Use the provided buttons and ListView to interact with the utility and manage VSA packages.
3. **Search for Practices** - Use the search bar to quickly find specific practices in the ListView.
4. **Manage Packages** - Use the Add, Delete, and Reload buttons to manage the package entries.
5. **Download and Install** - Use the corresponding buttons to download and install VSA packages for selected practices.
6. **Generate Batch Files** - Generate batch installation files as needed.
7. **Self-Destruct** - If needed, use the self-destruct feature to cleanly remove the utility and its configuration.

## Requirements

* AutoHotkey installed on the system.
* Appropriate permissions to download files, create directories, and install software.
* Internet access to download VSA packages.

## Important Notes

* Be cautious when using the self-destruct feature; it will permanently delete the script and configuration file.
* Ensure that you have backed up important data before making significant changes with this utility.
* Use this tool responsibly, considering the implications of installing/uninstalling software packages.

## License

VSADeployer is distributed under the MIT License. See the LICENSE file for more details.

## Contributing

Please read CONTRIBUTING.md for details on our code of conduct, and the process for submitting pull requests to us.

## Disclaimer

VSADeployer is not officially associated with Kaseya or VSA. Use this tool at your own risk, and ensure compliance with any relevant software licensing agreements.
