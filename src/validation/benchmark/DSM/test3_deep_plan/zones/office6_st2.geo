*Geometry 1.1,GEN,office6_st2 # tag version, format, zone name
*date Mon Dec 15 09:11:10 2008  # latest file modification 
office6_st2 is the north permiter office on 2nd level
# tag, X co-ord, Y co-ord, Z co-ord
*vertex,6.00000,44.00000,4.00000  #   1
*vertex,44.00000,44.00000,4.00000  #   2
*vertex,44.00000,50.00000,4.00000  #   3
*vertex,6.00000,50.00000,4.00000  #   4
*vertex,6.00000,44.00000,8.00000  #   5
*vertex,44.00000,44.00000,8.00000  #   6
*vertex,44.00000,50.00000,8.00000  #   7
*vertex,6.00000,50.00000,8.00000  #   8
*vertex,37.01665,50.00000,4.73509  #   9
*vertex,12.98335,50.00000,4.73509  #  10
*vertex,12.98335,50.00000,7.26491  #  11
*vertex,37.01665,50.00000,7.26491  #  12
*vertex,36.39999,50.00000,4.80000  #  13
*vertex,13.60000,50.00000,4.80000  #  14
*vertex,13.60000,50.00000,7.20000  #  15
*vertex,36.39999,50.00000,7.20000  #  16
# 
# tag, number of vertices followed by list of associated vert
*edges,4,1,2,6,5  #  1
*edges,4,2,3,7,6  #  2
*edges,10,3,4,8,7,3,9,12,11,10,9  #  3
*edges,4,4,1,5,8  #  4
*edges,4,5,6,7,8  #  5
*edges,4,1,4,3,2  #  6
*edges,10,9,10,11,12,9,13,16,15,14,13  #  7
*edges,4,13,14,15,16  #  8
# 
# surf attributes:
#  surf name, surf position VERT/CEIL/FLOR/SLOP/UNKN
#  child of (surface name), useage (pair of tags) 
#  construction name, optical name
#  boundary condition tag followed by two data items
*surf,ptn_o10,VERT,-,PARTN,-,party_wall_n,OPAQUE,ANOTHER,28,05  #   1 ||< Wall-7:off10_st2
*surf,ptn_o5,VERT,-,PARTN,-,party_wall_n,OPAQUE,ANOTHER,19,04  #   2 ||< ptn_o6:office5_st2
*surf,north,VERT,-,WALL,-,Wall_EW_noti,OPAQUE,EXTERIOR,0,0  #   3 ||< external
*surf,ptn_o7,VERT,-,PARTN,-,party_wall_n,OPAQUE,ANOTHER,21,02  #   4 ||< Wall-2:office7_st2
*surf,ceiling,CEIL,-,PARTN,-,inv_pa_fl_no,OPAQUE,ANOTHER,34,06  #   5 ||< Base-6:office6_st3
*surf,floor,FLOR,-,PARTN,-,pa_fl_notion,OPAQUE,ANOTHER,06,05  #   6 ||< ceiling:office_6
*surf,win_frame,VERT,north,F-FRAME,CLOSED,frame_notion,OPAQUE,EXTERIOR,0,0  #   7 ||< external
*surf,win_glz,VERT,win_frame,C-WINDOW,CLOSED,window_Not_G,Glaz_notiona,EXTERIOR,0,0  #   8 ||< external
# 
*insol,3,0,0,0  # default insolation distribution
# 
# shading directives
*shad_calc,none  # no temporal shading requested
# 
*insol_calc,none  # no insolation requested
# 
*base_list,1,6,   228.00 0  # zone base list
# 
*bridge_start,0.100,16.533,16.533,165.334  # user fraction,losspercent W/K, total heat loss W/K and total UA W/K
*end_bridge