# Image-processing-through-complex-networks-and-CNN-training
Leonardo Parancola, computer engineering degree thesis - UNIPD

Note that the construction of the direct graph does not consider the bidirectional case of the edges.
To do that, simply consider > instead of >= in the diffIntensity inequality, that are respectively I(i) < I(j) and I(i) <= I(j).
Considering the > case there can be some missing edges.

<b>EXPERIMENT'S FILES</b><br>
The script to run is AlexNet, which initializes all the useful variables and the pre-trained network.
One important variable is 'method' that is used to choose one of the following methods:
<ol>
  <li>is the method without image pre-processing;</li>
  <li>is the method which considers the image pre-processing calculating the 'outdegree', the 'outdegree' considering the sum of the weight of the out-edges and the 'indegree' with the sum of the weight of the in-edges;</li>
  <li>is the method which includes the calculation of the 'outdegree', like the method above, the 'incloseness' and the 'outcloseness' for the image pre-processing;</li>
  <li>in this method, three different methods to pre-process the image are used. These methods are: 'outdegree', 'outcloseness' and 'indegree'.</li>
</ol> 
 
After the value of the radius is decided, the image processing is done before starting the training of the network.

When the training finishes, the results will be saved into one main folders: score.

The subfolder, named score, contain .mat files. Into these files, there is all the information about the measured scores (for each fold).
The files are named as 'score_method_used_radius' which depends on the method used.

<h3>fromRGBToCustomFormat.m</h3> 
<b>function IM = fromRGBToCustomFormat(rgbImage, radius, method)</b>

      rgbImage = RGB image to process.
    	radius = considered radius for the graph construction.
    	method = which method is used.
    
    	IM = processed image to return.

	This function provides the steps to convert an image from the RGB format
	to a customized one.
	Firstly, the image is converted in a gray-scale format.
	Secondly, the corresponding graph of the image is constructed, using the 
	createCNFromImage function.
	Finally, from the graph are calculated three different matrices, which
	are going to substitute the original three matrices of the RGB image.
	These matrices are obtained using calculateKV, calculateKS and calculateKE
	funcitons.


<h3>createCNFromImage.m</h3> 
	<b>function CN = createCNFromImage(image, radius, method)</b>

	image = gray-scale image.
    	radius = radius to consider for the graph construction.
    	method = method to use.
    
    	CN = digraph obtained from image processing.

	Function that converts an image from a gray-scale format to a digraph.
	Two vertices are connected if dist(i, j) <= radius and I(i) < I(j),
	where dist is the Euclidean distance between i and j and I is the value 
	associated to the node.
	The nodes of the graph are the pixels of the image, each containing the
	intensity value.
	Initially, all the possible combinations of the coordinates are defined.

	Then, two matrices are calculated: 
	  - euclideanDistance, that contains the Euclidean distance between all the 
		  possible pairs of coordinates;
	  - diffIntensity, which contains the difference between all the possible 
		  pairs of intensity.

	After that, the adjacency matrix is calculated in order to construct the
	corresponding digraph. A value of the matrix is 1 if 
	(euclideanDistance <= radius) & (euclideanDistance > 0) & (diffIntensity > 0),
	0 otherwise.

	Starting from the value of the radius (and depending of the method), the
	weights of the edges are calculated. The resulting matrix is multiplied,
	value by value, with the adjacency matrix, in order to assign the
	corresponding weight to the edge.

	Finally, the graph CN is created.


<h3>calculateKV.m</h3>
	<b>function kv = calculateKV(CN, siz, method)</b> 

	CN = digraph.
  	siz = image size.
  	method = method to use.
    
  	kv = resulting matrix with the same dimension of the image.

	Depending on the method, the resulting matrix is obtained by calculating 
	some topological characteristics (see at the beginning of this file).


<h3>calculateKS.m</h3>
	<b> function ks = calculateKS(CN, siz, method)</b> 

	CN = digraph.
    	siz = image size.
   	method = method to use.
    
    	ks = resulting matrix with the same dimension of the image.

	Depending on the method, the resulting matrix is obtained by calculating 
	some topological characteristics (see at the beginning of this file).


<h3>calculateKE.m</h3>
	<b> function ke = calculateKE(CN, siz, method)</b> 

	CN = digraph.
    	siz = image size.
    	method = method to use.
    
   	ke = resulting matrix with the same dimension of the image.

	Depending on the method, the resulting matrix is obtained by calculating 
	some topological characteristics (see at the beginning of this file).


<b>RESULTS' FILES:</b><br>
The scripts ensemble.m, confusionMatrix.m and comparisonChart.m give the results as:
<ul>
  <li>the scores for the ensemble into the score directory;</li>
  <li>a confusion matrix;</li>
  <li>charts of comparison between the methods.</li>
</ul>  
