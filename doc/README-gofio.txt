README-gofio.txt
ver 0.02
Brett Lee
======================================


HOWTO on running FIO tests and presenting the results.


Tested using:
CentOS 6.4  : 7050f40269b90aad2ffa0c004887cbc2   fio-2.1.4-1.el6.rf.x86_64.rpm
SLES 11 SP2 : 940890e03b63fd729e906d80d888443b   fio-2.1.4-19.1.x86_64.rpm



1.  Create a unique RUN directory for each successive RUN.

	# mkdir -p ~/work/gofio-run01

		
2.  Unpack gofio.tgz to the RUN directory:

	# cd ~/work/gofio-run01
	# tar zxf ~/work/gofio.tgz 
	# ls -p
	bin/ config/ doc/ logs/ results/
	# ls bin
	gofio-csv.sh  gofio-logs.sh  gofio-run.sh

	Directory names are:

		RUN	~/work/gofio-run01/
		BIN	~/work/gofio-run01/bin/
		LOGS	~/work/gofio-run01/logs/
		RESULTS	~/work/gofio-run01/results/


3.  Configure gofio

	# vi config/config.txt

		Configure as needed...
		This file will be used by gofio-run.sh and gofio-csv.sh


4.  Run the RUN script:

	# cd logs/                (yes, you must be in the LOGS directory)
	# vi ../bin/gofio-run.sh

		Review / configure scope of test suite as needed...

	# ../bin/gofio-run.sh

		This will create performance LOG files in `pwd` (logs/).


4.  Run the LOGS script:

	This parses the LOG files to an intermediate results file:

	# cd ~/work/gofio-run01   (yes, you must be in the RUN directory)
	# ./bin/gofio-logs.sh > ./results/results.raw (yes, this output path/name must be used)


5.  Run the CSV script:

	This parses the intermediate file into individual CSV files.

	# cd results/             (yes, you must be in the RESULTS directory)
	# ../bin/gofio-csv.sh

	The latter will produce CSV files in `pwd`.


6.  Import the approprate CSV file(s) into Excel and graph them.

	The file "results.csv" has all the data.
	The other files contain subsets of the data.

