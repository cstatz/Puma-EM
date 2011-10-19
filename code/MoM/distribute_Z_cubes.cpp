#include <stdio.h>
#include <stdlib.h>
#include <fstream>
#include <iostream>
#include <string>
#include <complex>
#include <cmath>
#include <blitz/array.h>
#include <blitz/tinyvec-et.h>
#include <vector>
#include <algorithm>
#include <mpi.h>

using namespace blitz;

#include "octtree.h"
#include "mesh.h"
#include "EMConstants.h"

int main(int argc, char* argv[]) {

  MPI::Init();
  int ierror;
  int num_procs = MPI::COMM_WORLD.Get_size();
  int my_id = MPI::COMM_WORLD.Get_rank();

  string simuDir = ".";
  if ( argc > 2 ) {
     if( string(argv[1]) == "--simudir" ) simuDir = argv[2];
  }

  // general variables
  const string TMP = simuDir + "/tmp" + intToString(my_id);
  const string OCTTREE_DATA_PATH = TMP + "/octtree_data/";
  const string MESH_DATA_PATH = TMP + "/mesh/";
  writeIntToASCIIFile(OCTTREE_DATA_PATH + "CUBES_DISTRIBUTION.txt", 1);
  if (my_id==0) {
      Mesh target_mesh(MESH_DATA_PATH);
      Octtree octtree(OCTTREE_DATA_PATH, target_mesh.cubes_centroids, my_id, num_procs);
    }
  ierror = MPI_Barrier(MPI::COMM_WORLD);
  // we write 0 on the file
  writeIntToASCIIFile(OCTTREE_DATA_PATH + "CUBES_DISTRIBUTION.txt", 0);
  MPI::Finalize();
  return 0;
}