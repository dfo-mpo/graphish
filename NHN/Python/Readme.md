# objective:
This file provide a summary of the functuality of the Python codes and their input and output.



Segment to segment:
This file represents a relationship between two segments. `Segment_id_first` is the segment id of a segment and `segment_id_second` is the id of a segment that the first segment flows to.
  

Python file:
segment-to-junction-AND-seg_to_seg.ipynb
River_segment.csv
This file has segment_id and river names. This can be used to create a relationship between the two nodes (segment and river nodes).






Input file:
From open Canada shape file 


Feature:
Segment_id:
As the ids are not consistent, we use the row number and the DATASETNAME to create an ID for each row.


River_name:
Name of the river




Code:
Javad-Python/River-extraction.ipynb


________________


Points-to-segment  ,points-to-water bodies, Barrier-to-segments, barrier-to-water bodies
Study-to-segments and study-to-waterbodies
Folders
Contain CSV files that create a relationship between segment_id, as described above, and the file provided by Rubaba, the Cabin data and the barrier data, by finding the closest segment to a point location.


Input file:
From open Canada shape file for segments
From Cabin data, cleaned NL study csv file for points


Code:
Javad-Python/Cabin-study-waterbody-segments-connection.ipynb




Junction-to-water bodies:
This folder contains a csv file that creates relationships between junctions and water bodies. The distance between a junction and its closest water body is given in meters.












________________
OLD Notes:
Ignore these:
________________


Study_segment Folder
Contains shape files and a CSV file that create a relationship between segment_id, as described above, and the study by finding the closest segment to a study location.


Input file:
From open Canada shape file 
From Cabin data, cleaned NL study csv file


Features: 
Kept all the features of  study and segment_id from segment file.


Code:
Javad-Python/Cabin-study-waterbody-segments-connection.ipynb






________________




Study_waterbody Folder:


Similar to Study_segment, replace segment with water body


________________




Salmonids-waterbody and salmonids-segmen folders:
The same method was used to find the closest water bodies and segments to Salmonids dataset locations.