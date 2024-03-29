pragma circom 2.0.4;

include "./utils/mimc.circom";

template GetMerkleRoot(k){
// k is depth of tree

    signal input leaf;
    signal input paths2_root[k];
    signal input paths2_root_pos[k];

    signal output out;

    // hash of first two entries in tx Merkle proof
    component merkle_root[k];
    merkle_root[0] = MultiMiMC7(2,91);
    merkle_root[0].in[0] <== paths2_root[0] - paths2_root_pos[0]* (paths2_root[0] - leaf);
    merkle_root[0].in[1] <== leaf - paths2_root_pos[0]* (leaf - paths2_root[0]);

    // hash of all other entries in tx Merkle proof
    for (var v = 1; v < k; v++){
        merkle_root[v] = MultiMiMC7(2,91);
        merkle_root[v].in[0] <== paths2_root[v] - paths2_root_pos[v]* (paths2_root[v] - merkle_root[v-1].out);
        merkle_root[v].in[1] <== merkle_root[v-1].out - paths2_root_pos[v]* (merkle_root[v-1].out - paths2_root[v]);
    }

    // output computed Merkle root
    out <== merkle_root[k-1].out;
}

template LeafExistence(k, l){
// k is depth of tree
// l is length of preimage of leaf

    signal input preimage[l]; 
    signal input root;
    signal input paths2_root_pos[k];
    signal input paths2_root[k];

    component leaf = MultiMiMC7(l,91);
    for (var i = 0; i < l; i++){
        leaf.in[i] <== preimage[i];
    }

    component computed_root = GetMerkleRoot(k);
    computed_root.leaf <== leaf.out;

    for (var w = 0; w < k; w++){
        computed_root.paths2_root[w] <== paths2_root[w];
        computed_root.paths2_root_pos[w] <== paths2_root_pos[w];
    }

    // equality constraint: input tx root === computed tx root 
    root === computed_root.out;
}

template Withdrawal() {
  
}

component main = Withdrawal();