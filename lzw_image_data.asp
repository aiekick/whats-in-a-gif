<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>3MF Project: What's In A GIF - LZW Image Data</title>
	<script type="text/javascript"></script>
	<link rel="stylesheet" href="proj.css" />
	<style type="text/css">
	.byte {font-family: Courier, fixed;
		padding: .2em}
	.gif_header {background-color: #f9E89D}
	.gif_screen {background-color: #C8DBD9}
	.gif_color {background-color: #E1E1E1}
	.gif_graphic {background-color: #F9EB9D}
	.gif_imgdesc {background-color: #C2D1DC}
	.gif_imgdata {background-color: #D0C4C4}
	.gif_trailer {background-color: #f9E89D}
	.gif_ext {background-color: #D0CFAE}
	#global_color_size {margin-left: auto; margin-right:auto; border:1px solid black;}
	#global_color_size th {border-bottom: 1px solid #666666}
	#global_color_size td {text-align:center;}
	.code_table {margin-left: auto; margin-right:auto; border:1px solid black;}
	.code_table th {text-align: left; border-bottom: 1px solid #666666}
	.alg_steps {margin: 0 auto; border: 1px solid black}
	.alg_steps th, .alg_steps td {border: 1px solid black}
	.alg_steps .index {padding: 0 .3em}
	.alg_steps .processed {color: #CCC}
	.alg_steps .buffer {background: #C8DBD9 url(highlight_green.gif) repeat-x center left;
		border-top: 1px solid #AAA2A2; border-bottom: 1px solid #AAA2A2;}
	.alg_steps .current {background: #D0C4C4 url(highlight_purple.gif) repeat-x center left;
		border-top: 1px solid #98A5A4; border-bottom: 1px solid #98A5A4;}
	</style>
</head>
<body>
<div id="nav"><a href="../index.html">back to main lab page</a></div>
<div id="body">


<h1>Project: <span class="projname">What's In A GIF - LZW Image Data</span></h1>

<div class="projdesc">
	<p>
	Now let's look at exactly how we go about storing an image in a GIF file. The GIF
	format is a raster format, meaning it stores image data by remembering
	the color of every pixel in the image. More specifically, GIF files remember
	the index of the color in a color table for each pixel. To make that more clear,
	let me again show the sample image we used in the <a href="bits_and_bytes.asp">first section</a>.
	</p>
	<table style="margin-left: auto; margin-right:auto;"><tr>
	<td style="text-align:center; vertical-align: top; padding: 5px; width:30%"><h3>Actual Size</h3><img src="images/sample_1.gif" alt="sample gif, actual size" title="Actual Size" width="10" height="10" style="padding: 20px" /><br/>(10x10)</td>
	<td style="text-align:center; vertical-align: top; padding: 5px;; width:40%"><h3>Enlarged</h3><img src="images/sample_1_enlarged.gif" alt="sample gif, enlarged" title="Enlarged" width="100" height="100" /><br/>(100x100)</td>
	<td style="vertical-align: top; padding: 5px; width:30%"><h3>Color Table</h3>
		<table>
		<tr><th>Index</th><th>Color</th></tr>
		<tr><td>0</td><td><span style="color:#FFFFFF; background: #000000; font-weight: bold">White</span></td></tr>
		<tr><td>1</td><td><span style="color:#FF0000; font-weight: bold">Red</span></td></tr>
		<tr><td>2</td><td><span style="color:#0000FF; font-weight: bold">Blue</span></td></tr>
		<tr><td>3</td><td><span style="font-weight: bold">Black</span></td></tr>
		</table>
	</td>
	</tr></table>
	<p>
	The color table came from the global color table block. The colors are listed
	in the order which they appear in the file. The first color is given an index
	of zero. When we send the codes, we always start at the top left of the image
	and work our way right. When we get to the end of the line, the very next code
	is the one that starts the next line. (The decoder will &quot;wrap&quot; the image based
	on the image dimensions.) We could encode our sample image in the following way:</p>

	<blockquote><p>1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 1,
	1, 1, 1, 1, 2, 2, 2, 2, 2, 1, 1, 1, 0, 0, 0, 0, 2, 2, 2, 1, 1, 1,
	0, 0, 0, 0, 2, 2, 2, ...</p></blockquote>

	<p>
	The above listing shows the sequence required to render the first five lines of the
	image. We could continue with this method until we've specified the color for every
	pixel; however, this can result in a rather large file. Luckily for us, the GIF
	format allows us to take advantage of repetition in our output and to
	compress our data.
	</p>

	<p>
	[ Much of the following information came from John Barkaus's
	<a href="http://www.danbbs.dk/~dino/whirlgif/lzw.html">LZW and GIF Explained</a>
        (<a href="http://web.archive.org/web/20050217131148/http://www.danbbs.dk/~dino/whirlgif/lzw.html">archive</a>).
	I've tried to provide more detailed samples as well
	as illustrations to make the process even clearer; but if I've
	made something unclear, I would recommend consulting John's original guide. ]
	</p>


	<h2><a name="lzw_compression">LZW Compression</a></h2>
	<p>
	LZW compression is used in GIF files to reduce file size. (Actually it is
	a slight variation from the standard LZW for use in GIF images.) This method
	requires building a <strong>code table</strong>. This code table will allow
	us to use special codes to indicate a sequence of colors rather than just one at
	a time.  The first thing we do is to <em>initialize the code table</em>.
	We start by adding a code for each of the colors in the color table. This would be a
	local color table if one was provided, or the global color table. (I will
	be starting all codes with &quot;#&quot; to distinguish them from color indexes.)
	</p>
		<table class="code_table">
		<tr><th>Code</th><th>Color(s)</th></tr>
		<tr><td>#0</td><td>0</td></tr>
		<tr><td>#1</td><td>1</td></tr>
		<tr><td>#2</td><td>2</td></tr>
		<tr><td>#3</td><td>3</td></tr>
		<tr><td>#4</td><td>Clear Code</td></tr>
		<tr><td>#5</td><td>End Of Information Code</td></tr>
		</table>
	<p>
	I added a code for each of the colors in the global color table of our sample
	image. I also snuck in two special control codes.
	(These special codes are only used in the GIF version of LZW, not in
	standard LZW compression.) Our code table is now considered initialized.
	</p>
	<p>
	Let me now explain what those special codes are for. The first new code
	is the <em>clear code</em> (CC). Whenever you come across the clear code
	in the image data, it's your cue to reinitialize the code table. (I'll
	explain why you might need to do this in a bit.) The second new code
	is the <em>end of information code</em> (EOI). When you come across
	this code, this means you've reached the end of the image. Here I've placed
	the special codes right after the color codes, but actually the value of
	the special codes depends on the value of the LZW minimum code size
	from the image data block. If the LZW minimum code size is the same as
	the color table size, then special codes immediately follow the colors; however
	it is possible to specify a larger LWZ minimum code size which may leave
	a gap in the codes where no colors are assigned. This can be
	summarized in the <a name="color_table_size">following table</a>.
	</p>

	<div style="text-align:center">
	<table id="global_color_size">
	<tr><th>LWZ Min Code<br/>Size</th><th>Color<br/>Codes</th><th>Clear<br/>Code</th><th>EOI<br/>Code</th></tr>
	<tr><td>2</td><td>#0-#3</td><td>#4</td><td>#5</td></tr>
	<tr><td>3</td><td>#0-#7</td><td>#8</td><td>#9</td></tr>
	<tr><td>4</td><td>#0-#15</td><td>#16</td><td>#17</td></tr>
	<tr><td>5</td><td>#0-#31</td><td>#32</td><td>#33</td></tr>
	<tr><td>6</td><td>#0-#63</td><td>#64</td><td>#65</td></tr>
	<tr><td>7</td><td>#0-#127</td><td>#128</td><td>#129</td></tr>
	<tr><td>8</td><td>#0-#255</td><td>#256</td><td>#257</td></tr>
	</table>
	</div>

	<p>
	Before we proceed, let me define two more terms. First the <strong>index
	stream</strong> will be the list of indexes of the color for each of
	the pixels. This is the input we will be compressing. The <strong>code
	stream</strong> will be the list of codes we generate as output. The
	<strong>index buffer</strong> will be the list of color indexes
	we care &quot;currently looking at.&quot; The index buffer will contain a list
	of one or more color indexes. Now we can step though the LZW
	compression algorithm. First, I'll just list the steps. After that
	I'll walk through the steps with our specific example.
	</p>
	<ul>
	<li>Initialize code table</li>
	<li>Always start by sending a clear code to the code stream.</li>
	<li>Read first index from index stream. This value is now the value
	for the index buffer</li>
	<li>&lt;LOOP POINT&gt;</li>
	<li>Get the next index from the index stream to the index buffer. We will
	call this index, K</li>
	<li>Is index buffer + K in our code table?</li>
	<li>Yes:
		<ul>
		<li>add K to the end of the index buffer</li>
		<li>if there are more indexes, return to LOOP POINT</li>
		</ul>
	</li>
	<li>No:
		<ul>
		<li>Add a row for index buffer + K into our code table with
		the next smallest code</li>
		<li>Output the code for just the index buffer to our code steam</li>
		<li>Index buffer is set to K</li>
		<li>K is set to nothing</li>
		<li>if there are more indexes, return to LOOP POINT</li>
		</ul>
	</li>
	<li>Output code for contents of index buffer</li>
	<li>Output end-of-information code</li>
	</ul>

	<p>
	Seems simple enough, right? It really isn't all that bad. Let's walk though
	our sample image to show you how this works. (The steps I will be describing
	are summarized in the following table. Numbers highlighted in green are in the
	index buffer; numbers in purple are the current K value.)
	We have already initialized our code table. We start by doing two things:
	we output our clear code (#4) to the code stream, and we read the first
	color index from the index stream, 1, into our index buffer [Step 0].
	</p>
	<p>
	Now we enter the main loop of the algorithm. We read the next index in the
	index stream, 1, into K [Step 1]. Next we see if we have a record for the index buffer
	plus K in the code stream. In this case we looking for 1,1. Currently our
	code table only contains single colors so this value is not in there. Now we
	will actually add a new row to our code table that does contain this value.
	The next available code is #6, we will let #6 be 1,1. Note that we do not
	actually send this code to the code stream, instead we send just the code for
	the value(s) in the index buffer. The index buffer is just 1 and the code for
	1 is #1. This is the code we output. We now reset the index buffer to just
	the value in K and K becomes nothing. [Step 2].
	</p>
	<p>
	We continue by reading the next index into K. [Step 3]. Now K is 1 and the
	index buffer is 1. Again we look to see if there is a value in our code
	table for the buffer plus K (1,1) and this time there is. (In fact we just
	added it.) Therefore we add K to the end of the index buffer and clear out
	K. Now our index buffer is 1,1. [Step 4].
	</p>
	<p>
	The next index in the index stream is yet another 1. This is our new K [Step 5].
	Now the index buffer plus K is 1,1,1 which we do not have a code for in
	our code table. As we did before, we define a new code and add it to the
	code table. The next code would be #7; thus #7 = 1, 1, 1. Now we kick out
	the code for just the values in the index buffer (#6 = 1,1) to the code
	stream and set the index buffer to be K. [Step 6].
	</p>

	<table class="alg_steps" cellspacing="0">
	<tbody>
	<tr>
		<th>Step</th>
		<th>Action</th>
		<th>Index Stream</th>
		<th>New Code Table Row</th>
		<th>Code Stream</th>
	</tr>
	<tr>
		<td>0</td>
		<td>Init</td>
		<td><span class="processed"></span><span class="buffer"><span class="index">1</span></span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4</td>
	</tr>

	<tr>
		<td>1</td>
		<td>Read</td>
		<td><span class="processed"></span><span class="buffer"><span class="index">1</span></span><span class="current"><span class="index">1</span></span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4</td>
	</tr>

	<tr>
		<td>2</td>
		<td>Not Found</td>
		<td><span class="processed"><span class="index">1</span></span><span class="buffer"><span class="index">1</span></span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>#6 - 1, 1</td>
		<td>#4 #1</td>
	</tr>

	<tr>
		<td>3</td>
		<td>Read</td>
		<td><span class="processed"><span class="index">1</span></span><span class="buffer"><span class="index">1</span></span><span class="current"><span class="index">1</span></span><span class="index">1</span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1</td>
	</tr>

	<tr>
		<td>4</td>
		<td>Found</td>
		<td><span class="processed"><span class="index">1</span></span><span class="buffer"><span class="index">1</span><span class="index">1</span></span><span class="index">1</span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1</td>
	</tr>

	<tr>
		<td>5</td>
		<td>Read</td>
		<td><span class="processed"><span class="index">1</span></span><span class="buffer"><span class="index">1</span><span class="index">1</span></span><span class="current"><span class="index">1</span></span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1</td>
	</tr>

	<tr>
		<td>6</td>
		<td>Not Found</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span></span><span class="buffer"><span class="index">1</span></span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>#7 - 1, 1, 1</td>
		<td>#4 #1 #6</td>
	</tr>
	</tbody>
	<tbody id="compress_more">

	<tr>
		<td>7</td>
		<td>Read</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span></span><span class="buffer"><span class="index">1</span></span><span class="current"><span class="index">1</span></span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1 #6</td>
	</tr>

	<tr>
		<td>8</td>
		<td>Found</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span></span><span class="buffer"><span class="index">1</span><span class="index">1</span></span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1 #6</td>
	</tr>

	<tr>
		<td>9</td>
		<td>Read</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span></span><span class="buffer"><span class="index">1</span><span class="index">1</span></span><span class="current"><span class="index">2</span></span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1 #6</td>
	</tr>

	<tr>
		<td>10</td>
		<td>Not Found</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span></span><span class="buffer"><span class="index">2</span></span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>#8 - 1, 1, 2</td>
		<td>#4 #1 #6 #6</td>
	</tr>

	<tr>
		<td>11</td>
		<td>Read</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span></span><span class="buffer"><span class="index">2</span></span><span class="current"><span class="index">2</span></span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1 #6 #6</td>
	</tr>

	<tr>
		<td>12</td>
		<td>Not Found </td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span></span><span class="buffer"><span class="index">2</span></span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>#9 - 2, 2</td>
		<td>#4 #1 #6 #6 #2</td>
	</tr>

	<tr>
		<td>13</td>
		<td>Read</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span></span><span class="buffer"><span class="index">2</span></span><span class="current"><span class="index">2</span></span><span class="index">2</span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1 #6 #6 #2</td>
	</tr>

	<tr>
		<td>14</td>
		<td>Found </td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span></span><span class="buffer"><span class="index">2</span><span class="index">2</span></span><span class="index">2</span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1 #6 #6 #2</td>
	</tr>

	<tr>
		<td>15</td>
		<td>Read</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span></span><span class="buffer"><span class="index">2</span><span class="index">2</span></span><span class="current"><span class="index">2</span></span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1 #6 #6 #2</td>
	</tr>

	<tr>
		<td>16</td>
		<td>Not Found</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span></span><span class="buffer"><span class="index">2</span></span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>#10 - 2, 2, 2</td>
		<td>#4 #1 #6 #6 #2 #9</td>
	</tr>

	<tr>
		<td>17</td>
		<td>Read</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span></span><span class="buffer"><span class="index">2</span></span><span class="current"><span class="index">2</span></span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1 #6 #6 #2 #9</td>
	</tr>

	<tr>
		<td>18</td>
		<td>Found</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span></span><span class="buffer"><span class="index">2</span><span class="index">2</span></span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1 #6 #6 #2 #9</td>
	</tr>

	<tr>
		<td>19</td>
		<td>Read</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span></span><span class="buffer"><span class="index">2</span><span class="index">2</span></span><span class="current"><span class="index">1</span></span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1 #6 #6 #2 #9</td>
	</tr>

	<tr>
		<td>20</td>
		<td>Not Found</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span></span><span class="buffer"><span class="index">1</span></span><span class="index">1</span><span class="index">1</span><span class="index">1</span>...</td>
		<td>#11 - 2, 2, 1</td>
		<td>#4 #1 #6 #6 #2 #9 #9</td>
	</tr>

	<tr>
		<td>21</td>
		<td>Read</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span></span><span class="buffer"><span class="index">1</span></span><span class="current"><span class="index">1</span></span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1 #6 #6 #2 #9 #9</td>
	</tr>

	<tr>
		<td>22</td>
		<td>Found</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span></span><span class="buffer"><span class="index">1</span><span class="index">1</span></span><span class="index">1</span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1 #6 #6 #2 #9 #9</td>
	</tr>

	<tr>
		<td>23</td>
		<td>Read</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span></span><span class="buffer"><span class="index">1</span><span class="index">1</span></span><span class="current"><span class="index">1</span></span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1 #6 #6 #2 #9 #9</td>
	</tr>

	<tr>
		<td>24</td>
		<td>Found</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span></span><span class="buffer"><span class="index">1</span><span class="index">1</span><span class="index">1</span></span><span class="index">1</span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1 #6 #6 #2 #9 #9</td>
	</tr>

	<tr>
		<td>25</td>
		<td>Read</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span></span><span class="buffer"><span class="index">1</span><span class="index">1</span><span class="index">1</span></span><span class="current"><span class="index">1</span></span>...</td>
		<td>&nbsp;</td>
		<td>#4 #1 #6 #6 #2 #9 #9</td>
	</tr>

	<tr>
		<td>26</td>
		<td>Not Found</td>
		<td><span class="processed"><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">1</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">2</span><span class="index">1</span><span class="index">1</span><span class="index">1</span></span><span class="buffer"><span class="index">1</span></span>...</td>
		<td>#12 - 1, 1, 1, 1</td>
		<td>#4 #1 #6 #6 #2 #9 #9 #7</td>
	</tr>
	</tbody>
	</table>

	<p>
	I've included a few more steps to help you see the pattern. You keep going until
	you run out of indexes in the index stream. When there is nothing new to read,
	you simply write out the code for whatever values you may have in your index buffer.
	Finally you should send the end-of-information code to the code stream. In this
	example, that code is #5. (View the <a href="lzw_image_data_code_table.asp">
	complete code table</a>.)
	</p>
	<p>
	As you can see we dynamically built many new codes for our code table as
	we compressed the data. For large files this can turn into a large number
	of codes. It turns out that the GIF format specifies a maximum code of
	#4095 (this happens to be the largest 12-bit number). If you want to use a new code,
	you have to clear out all of your old codes. You do this by sending the
	clear code (which for our sample was the #4). This tells the decoder
	that you are reinitializing your code table and it should too. Then you
	start building your own codes again starting just after the value for
	your end-of-information code (in our sample, we would start again at #6).
	This means the same code in the code stream may mean different things
	when the code table changes. We can think of each time the code table is
	reset as a new "code unit". A code unit is just a combination of a code
	table and the codes generated from that code table. Most smaller images
	will only have one code unit.
	</p>
	<p>The final code stream would look like this:</p>

	<blockquote><p>#4 #1 #6 #6 #2 #9 #9 #7 #8 #10 #2 #12 #1 #14 #15 #6 #0 #21 #0 #10 #7 #22 #23
	#18 #26 #7 #10 #29 #13 #24 #12 #18 #16 #36 #12 #5</p></blockquote>

	<p>
	This is only 36 codes versus the 100 that would be required without compression.
	</p>



	<h2><a name="lzw_decompression">LZW Decompression</a></h2>
	<p>
	At some point we will probably need to turn this code stream back into
	a picture. To do this, we only need to know the values in the stream
	and the size of the color table that was used. That's it. You remember that
	big code table we built during compression? We actually have enough information
	in the code stream itself to be able to rebuild it.
	</p>

	<p>Again, I'll list the algorithm and then we will walk though an example. Let
	me define a few terms i will be using. CODE will be current code we're working
	with. CODE-1 will be the code just before CODE in the code stream. {CODE}
	will be the value for CODE in the code table. For example, using the code
	table we created during compression, if CODE=#7 then {CODE}=1,1,1.
	In the same way, {CODE-1} would be the value in the code table for the
	code that came before CODE. Looking at step 26 from the compression,
	if CODE=#7, then {CODE-1} would be {#9}, not {#6}, which was 2,2.
	</p>

	<ul>
	<li>Initialize code table</li>
	<li>let CODE be the first code in the code stream</li>
	<li>output {CODE} to index stream</li>
	<li>&lt;LOOP POINT&gt;</li>
	<li>let CODE be the next code in the code stream</li>
	<li>is CODE in the code table?</li>
	<li>Yes:
		<ul>
		<li>output {CODE} to index stream</li>
		<li>let K be the first index in {CODE}</li>
		<li>add {CODE-1}+K to the code table</li>
		</ul>
	</li>
	<li>No:
		<ul>
		<li>let K be the first index of {CODE-1}</li>
		<li>output {CODE-1}+K to index stream</li>
		<li>add {CODE-1}+K to code table</li>
		</ul>
	</li>
	<li>return to LOOP POINT</li>
	</ul>

	<p>
	Let's start reading though the code stream we've created to show how to
	turn it back into a list of color indexes.  The first value in the code
	stream should be a clear code. This means we should initialize our code
	table. To do this we must know how many colors  are in our color table.
	(This information comes from the first byte in the image data block in
	the file. More on this later.) Again we will set up codes #0-#3 to be each
	of the four colors and add in the clear code (#4)
	and end of information code (#5).
	</p>

	<p>The next step is to read the first color code. In the following table you
	will see the values of CODE highlighted in purple, and the values for
	CODE-1 highlighted in green. Our first CODE value is #1. We then output
	{#1}, or simply 1,  to the index stream [Step 0].</p>

	<p>Now we enter the main loop of the algorithm. The next code gets assigned
	to CODE which now makes that value #6. Next we check to see if this value
	is in our code table. At this time, it is not. This means we must find the
	first index in the value of {CODE-1} and call this K. Thus K = first index of
	{CODE-1} = first index of {#1} = 1. Now we output {CODE-1} + K to the index
	stream and add this value to our code table. The means we output 1,1 and
	give this value a code of #6 [Step 1].</p>

	<table class="alg_steps" cellspacing="0">
	<tr>
		<th>Step</th>
		<th>Action</th>
		<th>Code Stream</th>
		<th>New Code Table Row</th>
		<th>Index Stream</th>
	</tr>
	<tr>
		<td>0</td>
		<td>Init</td>
		<td><span class="processed">#4</span> <span class="current">#1</span> #6 #6 #2 #9 #9 #7 ...</td>
		<td>&nbsp;</td>
		<td>1</td>
	</tr>
	<tr>
		<td>1</td>
		<td>Not Found</td>
		<td><span class="processed">#4</span> <span class="buffer">#1</span> <span class="current">#6</span> #6 #2 #9 #9 #7 ...</td>
		<td>#6 - 1, 1</td>
		<td>1, 1, 1</td>
	</tr>
	<tr>
		<td>2</td>
		<td>Found</td>
		<td><span class="processed">#4 #1</span> <span class="buffer">#6</span> <span class="current">#6</span> #2 #9 #9 #7 ...</td>
		<td>#7 - 1, 1, 1</td>
		<td>1, 1, 1, 1, 1</td>
	</tr>
	<tr>
		<td>3</td>
		<td>Found</td>
		<td><span class="processed">#4 #1 #6</span> <span class="buffer">#6</span> <span class="current">#2</span> #9 #9 #7 ...</td>
		<td>#8 - 1, 1, 2</td>
		<td>1, 1, 1, 1, 1, 2</td>
	</tr>
	<tr>
		<td>4</td>
		<td>Not Found</td>
		<td><span class="processed">#4 #1 #6 #6</span> <span class="buffer">#2</span> <span class="current">#9</span> #9 #7 ...</td>
		<td>#9 - 2, 2</td>
		<td>1, 1, 1, 1, 1, 2, 2, 2</td>
	</tr>
	<tr>
		<td>5</td>
		<td>Found</td>
		<td><span class="processed">#4 #1 #6 #6 #2</span> <span class="buffer">#9</span> <span class="current">#9</span> #7 ...</td>
		<td>#10 - 2, 2, 2</td>
		<td>1, 1, 1, 1, 1, 2, 2, 2, 2, 2</td>
	</tr>
	<tr>
		<td>6</td>
		<td>Found</td>
		<td><span class="processed">#4 #1 #6 #6 #2 #9</span> <span class="buffer">#9</span> <span class="current">#7</span> ...</td>
		<td>#11 - 2, 2, 1</td>
		<td>1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 1, 1, 1</td>
	</tr>
	</table>

	<p>We start the loop again by reading the next code. CODE now would be
	#6 and this time we do have a record for this code in our code
	table. Thus we dump {#6} to the index stream which would be 1,1.
	Now we take the first index in {#6} and call that K. Here, {#6} has
	two indexes, the first of which is 1; thus K = 1. Before moving
	on, we add {CODE-1}+K to the code table. This #7 is now 1, 1, 1 [Step 2].</p>

	<p>I've included a few more steps so you can see the algorithm in action. While
	the explanation may sound complicated, you can see it's actually quite simple.
	You'll also notice that you end up building the exact same
	<a href="lzw_image_data_code_table.asp">code table</a>
	as the one that was created during compression. This is the reason that
	LZW is so great; we can just share the codes and not the table.</p>




	<h2><a name="lzw_bytes">Saving the Code Stream as Bytes</a></h2>
	<p>
	I've shown you how to go back and forth between index and code stream, but
	haven't told you what to do with them. The index stream is used to specify the
	color of each of the pixel of your image and really only shows up on screen.
	It is the code stream that is actually saved in the GIF files on your computer
	or transmitted over the internet. In order to save these code streams, we must
	turn them into bytes. The first thought might be to store each of the codes
	as its own byte; however this would limit the max code to just #255 and
	result in a lot of wasted bits for the small codes. To solve these problems,
	the GIF file format actually uses flexible <em>code sizes</em>.
	</p>
	<p>
	Flexible code sizes allow for further compression by limiting the bits
	needed to save the code stream as bytes. The <em>code size</em> is the number
	of bits it takes to store the value of the code. When we talk about bits,
	we're referring to the 1's and 0's that make up a byte. The codes are
	converted to their binary values to come up with the bits. To specify
	the code for #4, you would look at this binary equivalent, which is 100,
	and see that you would need three bits to store this value. The largest code
	value in our sample code stream is #36 (binary: 100100) which would
	take 6 bits to encode. Note that the number of bits I've just given is
	the minimum number. You can make the number take up more bits by adding
	zeros to the front.
	</p>
	<p style="text-align:center"><img src="images/image_data_block.gif" alt="GIF image data block layout" style="border: 1px solid black" /></p>
	<p>
	We need a way to know what size each of the codes are. Recall that the
	image data block begins with a single byte value called the
	<em>LZW minimum code size</em>. The GIF format allows sizes as small
	as 2 bits and as large as 12 bits. This minimum code size value is typically
	the number of bits/pixel of the image. So if you have 32 colors in your image,
	you will need 5 bits/pixel (for numbers 0-31 because 31 in binary is 11111).
	Thus, this will most likely be one more than the bit value for the size of the
	color table you are using. (Even if you only have two colors, the minimum
	code size most be at least 2.) Refer to the <a href="#color_table_size">
	code table above</a> to remind yourself how that works.
	</p>
	<p>
	Here's the funny thing: the value for minimum code size isn't actually the
	smallest code size that's used in the encoding process. Because the minimum
	code size tells you how many bits are needed just for the different colors
	of the image, you still have to account for the two special codes that we
	always add to the code table. Therefore the actual smallest code size that will
	be used is one more than the value specified in the &quot;minimum&quot; code size
	byte. I'll call this new value the <em>first code size</em>.
	</p>
	<p>
	We now know how many bytes the first code will be. This size will probably
	work for the next few codes as well, but recall that the GIF format
	allows for flexible code sizes. As larger code values get added to your
	code table, you will soon realize that you need larger code sizes if you
	were to output those values. When you are encoding the data, you increase
	your code size as soon as your write out the code equal to
	2^(current code size)-1. If you are decoding from codes to indexes,
	you need to increase your code size as soon as you add the code value that
	is equal to 2^(current code size)-1 to your code table. That is, the next
	time you grab the next section of bits, you grab one more.
	</p>
	<p>
	Note that the largest code size allowed is 12 bits. Once you've placed
	a value for #4095 in the code table, you should stop adding new codes.
	You can continue to emit existing code, but eventually you'll want to 
	emit a <em>clear code</em> to reinitialize the code table and start a 
	new code unit. This will also reset the code sizes back to the first 
	code size. It's almost as if you're encoding a new image at that point.
	</p>
	<p>
	Jumping back to our sample image, we see that we have a minimum code
	size value of 2 which means out first code size will be 3 bits long.
	Out first four codes, #1 #6 and #6, would be coded as 001 110 and 110.
	If you see at Step 10 of the encoding, we added a code of #8 to our code
	table. This is our clue to increase our code size because 8 is equal to
	2^3 (where 3 is our current code size). Thus, the next code we
	write out, #2, will use the new code size of 4 and therefore look
	like 0010. In the decoding process, we again would increase our code
	size when we read the code for #7 and would read the next 4, rather than
	the next 3 bits, to get the next code. In the sample table above this
	occurs in Step 2.
	</p>
	<p>
	Finally we must turn all these bit values into bytes. The lowest bit of the
	code bit value gets placed in the lowest available bit of the byte. After
	you've filled up the 8 bits in the byte, you take any left over bits and
	start a new byte. Take a look at the following illustration to see
	how that works with the codes from our sample image.
	</p>
	<p style="text-align:center"><img src="images/lzw_encoding_codes.gif" alt="Encoding LZW Codes" style="border: 1px solid black" / WIDTH="500" HEIGHT="220"></p>
	<p>
	You can see in the first byte that was returned (<span class="byte">8C</span>) that
	the lowest three bits (because that was our first code size) contain 100 which
	is the binary value of 4 so that would be the clear code we started with, #4. In
	the three bits to the left, you see 001 which out or first data code of #1. You can
	also see when we switched into code sizes of 4 bits in the second byte
	(<span class="byte">2D</span>).
	</p>
	<p>
	When you run out of codes but have filled less than 8 bits of the byte, you
	should just fill the remaining bits with zeros.
	</p>
	</p>
	Recall that the image data must be broken up into 
	<a href="bits_and_bytes.asp#image_data_block">data sub-blocks</a>.
	Each of the data sub-blocks begins with a byte that specifies how many
	bytes of data. The value will be between 1 and 255. After you read those bytes,
	the next byte indicates again how many bytes of data follow. You stop when you
	encounter a subblock that has a length of zero. That tells you when you've
	reached the end of the image data. In our sample the image the byte just after
	the LZW code size is <span class="byte">16</span> which indicates that 22
	bytes of data follow. After we reach those, we see the next byte is
	<span class="byte">00</span> which means we are all done.
	Note that nothing special happens when you move between sub-blocks; 
	that is, it's possible for the different bits
	for a particular code to span across bytes in different data sub-blocks.
	The bytes themselves are treated as an uninterrupted stream.
	</p>
	<p>
	Return codes from bytes the basically just the same process in reverse.
	A sample illustration of the process follows which shows how you would
	extract codes if the first code size were 5 bits.
	</p>
	<p style="text-align:center"><img src="images/lzw_decoding_bytes.gif" alt="Decoding LZW Bytes" style="border: 1px solid black" / WIDTH="500" HEIGHT="220"></p>


	<h2>Next: Animation and Transparency</h2>
	<p>That is pretty much everything you need to know to read or generate
	a basic image file. One of the reasons the GIF became such a popular
	format was because it also allowed for &quot;fancier&quot; features. These
	features include animation and transparency. Next we'll look
	at how those work.
	<a href="animation_and_transparency.asp">Continue...</a></p>

</div>




<div style="text-align:center; margin-top: 10px; padding-top: 10px; border-top: #cecece 1px solid">
<a href="../../index.html">home</a> -
<a href="https://github.com/MrFlick/whats-in-a-gif">github</a> -
<a href="mailto:me@matthewflickinger.com">me@matthewflickinger.com</a>
</div>

</div>


</body>

</html>


<!-- Localized -->
