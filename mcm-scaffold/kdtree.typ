#set text(size:12pt)
#set par(first-line-indent: 12pt)
=== Description
Considering problem 2 that the sensors data from 24 hours 
is requied to be processed, the size of matrix constructed
for differential calculation is extremely large ($4311 times 2881 times 2881 times 4$). It requires approximately 25GB of GPU memory if the data is stored in 64-bit floting point form which exceed the limit of household PC. Although we rent a A800 
GPU to obtain the accurate results, this is not pratical 
in because of limited access to top performance devices.

KD-Tree(KDT) however, is a data structure that can 
reduce the time complexity of searching algorithm to the nearest neighbor from $O(n)$ to $O(log(n))$. In this case, 
we build a KDT for every time stamps and query the nearest neighbors of the center of mass. Take some ponits 
on a two-dimensions surface as an example, KDT can be built
by the following steps:
#figure(caption: "Construct KD-Tree")[#image("2024-12-01-15-57-25.png")]
1. *Choose the splitting axis*: The building process begins by selecting the axis along which the points will be split. This is done based on the depth of the current node. At depth 0 (root node), the axis is typically the x-axis; at depth 1, the y-axis is chosen; This pattern repeats cyclically (x → y → x → y...).
2. *Sort the points*: Sort the set of points along the selected axis. For example, at depth 0, sort the points based on their x-coordinate, at depth 1, sort based on the y-coordinate.
3. *Select the median point*: After sorting the points along the chosen axis, the median point is selected. This point becomes the current node of the KD-Tree. The median point divides the points into two subsets: one to the left of the median and one to the right.
4. *Recursively construct left and right subtrees*: The left and right subsets of points (from step 3) are recursively processed. The same process (choosing an axis, sorting, finding the median, and recursively constructing subtrees) is applied to each subset. At each level of recursion, the axis alternates cyclically (x, y).
5. *Repeat until all points are used*: This process continues recursively until all points have been inserted into the tree, with each node corresponding to a median point of the subset of points it represents.
6. *Final result*:The final tree structure is a balanced binary tree where each node contains a point and references to its left and right children. The left child contains points with coordinates less than the node along the splitting axis, and the right child contains points with coordinates greater than the node along the splitting axis.
\

After the KDT is constructed, the nearest neighbors of the given points(center of mass in this problem) can be easily found in the KD-Tree.
#figure(caption: "KD-Tree Query")[#image("2024-12-01-16-15-05.png")]
1. *Start query from the root*:The search begins at the root node of the tree, where the goal is to find the point in the tree that is closest to the query point. Initially, we have no closest point, so we will update in the process.
2. *Compute the distance*: For the current node, compute the distance between the query point and the point at this node.
3. *Update the Best Match*:If the current node’s distance to the query point is smaller than any previously found distance, we update our best match. The node at the current level is now considered the closest point.
4. *Decide the Search Direction*:
  - The search proceeds down the tree based on the query point's coordinates and the current axis of the split. The tree splits on one of the three dimensions (x or y), and at each recursion depth.
  - If the query point's value on the current axis is smaller than the node’s value, we go down the left subtree; otherwise, we go down the right subtree. This determines which side of the tree we explore first.
5. *Recursive Search in the Chosen Subtree*:After deciding which subtree to search, we recursively call the search function to continue exploring the tree down that path. This continues until we reach a leaf node or the end of a branch.
6. *Check the Other Subtree (Pruning)*:
  - Once we’ve explored the first subtree, we check if there’s a possibility that the other subtree might contain a closer point. The key to this decision is based on whether the distance between the query point and the current node’s splitting plane is less than the current best distance.
  - If this condition holds true, we recursively search the other subtree. This pruning step significantly improves the efficiency of the search by avoiding unnecessary exploration of distant branches which saves 
  the time a lot compared with previous algorithm.
7. *Repeat Until the Tree is Fully Explored*:The process of calculating the distance, deciding the search direction, recursively exploring the chosen subtree, and pruning the other subtree continues until all relevant nodes are visited.
8. *Return the Nearest Neighbor*:After all relevant nodes are explored and pruned, the best match (the closest point) found during the traversal is returned as the nearest neighbor.
=== Implementation and results
With KDT data structure, the results of all 2881 time
stamps can be obtained within 2 seconds with MSVC release mode, eliminating the data reading time consumption.
Our program only takes abuout 200M memory and technology 
like CUDA is not required to run the program.
#align(center)[#figure(caption: "Results illustration")[
#table(columns: 2, align: center)[Time stamp][Optimal sensors indexed][19:23:36][41][19:24:06][330][19:24:36][210][19:25:06][120][19:25:36][42][19:26:06][320][19:26:36][254][19:27:06][151][19:27:36][291]
]<table-2>]
The results from the KDT algorithm are shown in #ref(<table-2>). It the same with the results from the algorithm in #ref(<table-1>) (matrix method).