PROGR_DIR_PATH =  $(PWD)/code

all:
	make install_open-mpi;
install_open-mpi:
	make libs;
	killall python; killall mpi_mlfma; rm -rf tmp*;
	./run.sh;
	killall python; killall mpi_mlfma; rm -rf tmp*;
install_lam-mpi:
	make libs;
	killall python; killall mpi_mlfma; rm -rf tmp*;
	./run.sh;
	killall python; killall mpi_mlfma; rm -rf tmp*;
package:
	make clean;
	python $(PROGR_DIR_PATH)/makePackage.py;
libs:
	cd $(PROGR_DIR_PATH)/MoM; make libs; make communicateZnearBlocks; make mpi_mlfma; make mesh_functions_seb; make mesh_cubes; make distribute_Z_cubes; make RWGs_renumbering; make compute_Z_near; make compute_SAI_precond;
communicateZnearBlocks:
	cd $(PROGR_DIR_PATH)/MoM; make communicateZnearBlocks;
mpi_mlfma:
	cd $(PROGR_DIR_PATH)/MoM; make mpi_mlfma;
distribute_Z_cubes:
	cd $(PROGR_DIR_PATH)/MoM; make distribute_Z_cubes;
RWGs_renumbering:
	cd $(PROGR_DIR_PATH)/MoM; make RWGs_renumbering;
compute_Z_near:
	cd $(PROGR_DIR_PATH)/MoM; make compute_Z_near;
compute_SAI_precond:
	cd $(PROGR_DIR_PATH)/MoM; make compute_SAI_precond;
mesh_functions_seb:
	cd $(PROGR_DIR_PATH)/MoM; make mesh_functions_seb;
mesh_cubes:
	cd $(PROGR_DIR_PATH)/MoM; make mesh_cubes;
documentation:
	cd doc; make documentation;
clean:
	rm -rf *~ *.pyc *.txt *.out *.tar *.gz *.tgz MPIcommand.sh GMSHcommand.sh __pycache__;
	cd run_in_out; rm -rf *~ *.pyc;
	cd $(PROGR_DIR_PATH); make clean;
	cd geo; make clean;
	cd installScripts; make clean;
	cd doc; make clean;
	rm -rf Puma-EM;
	rm -rf tmp*;
	rm -rf result* simuDir*;
docker_run:
	if [ "${shell docker images -q pumaem 2> /dev/null}" = "" ]; then \
		docker build . -t pumaem; \
	fi
	docker run --rm -u $(shell id -u ${USER} ):$(shell id -g ${USER} ) \
       -v $(shell pwd):/opt/share -w /opt/share pumaem /bin/bash -c \
       "make CFLAGS=\"-c -O3 -fPIC -pthread -march=native -mfpmath=both\""
documentation_from_docker:
	cd doc; make documentation_from_docker;
