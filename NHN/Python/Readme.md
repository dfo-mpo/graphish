# objective:

This file provides a summary of the functionality of the Python codes and their input and output. Also, it provides a guide to the folders shared on Google drive.

---

Segment to segment:
This file represents a relationship between two segments. `Segment_id_first` is the segment id of a segment, and `segment_id_second` is the id of a segment that the first segment flows to.
  
**Python file**:
segment-to-junction-AND-seg_to_seg.ipynb
River_segment.csv
This file has segment_id and river names. This can be used to create a relationship between the two nodes (segment and river nodes).
Input file:
From open Canada shape file 


Feature:
Segment_id:
As the ids are not consistent, we use the row number and the DATASETNAME to create an ID for each row.

---

River_name:
Name of the river
**Python file**:
Javad-Python/River-extraction.ipynb

---

Points-to-segment  ,points-to-water bodies, Barrier-to-segments, barrier-to-water bodies
Study-to-segments and study-to-waterbodies
Folders
Contain CSV files that create a relationship between segment_id, as described above, and the file provided by Rubaba, the Cabin data and the barrier data, by finding the closest segment to a point location.  
Input file:
From open Canada shape file for segments
From Cabin data, cleaned NL study csv file for points
**Python file**:
Cabin-study-waterbody-segments-connection.ipynb

---

Junction-to-water bodies:
This folder contains a csv file that creates relationships between junctions and water bodies. The distance between a junction and its closest water body is given in meters.


**Python file**:
Junction-to-water bodies.ipynb

---

Create a relationship between the combined dataset with lon and lat data and segments and/or water bodies.

**Python file**:
points-waterbody-segments-connection

---

Create a relationship between the junctions that are created from the segment dataset in segment-to-junction-AND-seg_to_seg.ipynb file and water bodies.

**Python file**:
junctions-to-waterbodies.ipynb

---
Create a relationship between the Barrier data and segments and/or water bodies.

**Python file**:
Barrier-waterbody-segments-connection-new.ipynb

---

In this notebook, the barrier dataset is explored. The file contains a layer for each barrier type. They are concatenated and exported.

**Python file**:
Barrier preprocessing.ipynb
