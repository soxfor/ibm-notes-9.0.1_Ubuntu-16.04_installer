#!/bin/bash

# Copyright 2016 Patrick Pedersen <ctx.xda@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Custom IBM Notes 9.0.1 patcher and installer for Ubuntu 16.04 systems

# Information on usage and execution is available in the README that comes with this file
# This installation script comes WITHOUT any IBM software and must be installed by the user himself

echo "Ubuntu 16.10 Installer for IBM notes 9.0.1"

if [ $(basename $1) == "ibm-notes-9.0.1.i586.deb" ]; then

	echo "Getting necessary unsupported/unofficial dependencies"

	mkdir temp_install

	wget http://mirrors.kernel.org/ubuntu/pool/main/libx/libxp/libxp6_1.0.2-1ubuntu1_i386.deb -P temp_install/

	function clean
	{
		sudo rm -R temp_*
	}

	sudo gdebi temp_install/libxp6_1.0.2-1ubuntu1_i386.deb
	if sudo apt-get -qq install libxp6; then
		echo "libxp6 : successfully installed"
	else
		echo "libxp6 : installation unsuccessful"
		exit 1
	fi

	echo "Patching the ibm-notes-9.0.1 package"
	echo "This may take a while depending on your hardware"

	# Give user time to read echo
	sleep 5

	sudo dpkg -X $1 ./temp_notes_unpacked
	sudo dpkg -e $1 ./temp_notes_unpacked/DEBIAN
	sudo sed -i 's/libcupsys2/libcups2/g' ./temp_notes_unpacked/DEBIAN/control
	sudo sed -i 's/libgnome-desktop-3-2/libgnome-desktop-3-12/g' ./temp_notes_unpacked/DEBIAN/control
	sudo sed -i 's/libpng12-0/libpng16-16/g' ./temp_notes_unpacked/DEBIAN/control
	sudo sed -i 's/ libxp6,//g' ./temp_notes_unpacked/DEBIAN/control
	sudo sed -i 's/libz1/zlib1g/g' ./temp_notes_unpacked/DEBIAN/control

	sudo dpkg -b temp_notes_unpacked $1

	echo "Done patching"

	clean

	echo "Installing IBM notes 9.0.1"

	# Give user time to read echo
	sleep 5

	sudo gdebi $1

	cd ../

	echo "Successfully installed IBM Notes 9.0.1"

else

	echo "Please open the installer using the ibm-notes-9.0.1 deb package"

fi
