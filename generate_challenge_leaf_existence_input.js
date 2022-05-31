const fs = require("fs");
const mimcjs = require("mimcjs");
const mimcMerkle = require("./MiMCMerkle.js");

const leaf1 = mimcjs.mimc([1, 2]);
const leaf2 = mimcjs.mimc([4, 5]);
const leaf3 = mimcjs.mimc([7, 8]);
const leaf4 = mimcjs.mimc([9, 8]);
const leafArray = [leaf1, leaf2, leaf3, leaf4];

const tree = mimcMerkle.treeFromLeafArray(leafArray);
const root = tree[0][0];
const leaf1Proof = mimcMerkle.getProof(0, tree, leafArray);
const leaf1Pos = [1, 1];

const inputs = {
    preimage: [1, 2, 3],
    root: root.toString(),
    paths2_root: [leaf1Proof[0].toString(), leaf1Proof[1].toString()],
    paths2_root_pos: leaf1Pos,
};

fs.writeFileSync("./input.json", JSON.stringify(inputs), "utf-8");
