*Geometry 1.1,GEN,bathrm # tag version, format, zone name
*date Fri Jul 17 13:33:43 2009  # latest file modification 
bathrm represents the 1st level bathroom
# tag, X co-ord, Y co-ord, Z co-ord
*vertex,6.00000,7.00000,2.20000  #   1
*vertex,3.00000,7.00000,2.20000  #   2
*vertex,3.00000,5.00000,2.20000  #   3
*vertex,6.00000,5.00000,2.20000  #   4
*vertex,6.00000,7.00000,4.40000  #   5
*vertex,3.00000,7.00000,4.40000  #   6
*vertex,3.00000,5.00000,4.40000  #   7
*vertex,6.00000,5.00000,4.40000  #   8
*vertex,6.00000,5.50000,2.20000  #   9
*vertex,4.50000,5.50000,2.20000  #  10
*vertex,4.50000,7.00000,2.20000  #  11
*vertex,4.50000,5.00000,2.20000  #  12
*vertex,3.00000,5.50000,2.20000  #  13
*vertex,4.50000,5.00000,4.40000  #  14
*vertex,5.00000,7.00000,3.80000  #  15
*vertex,4.00000,7.00000,3.80000  #  16
*vertex,4.00000,7.00000,4.20000  #  17
*vertex,5.00000,7.00000,4.20000  #  18
# 
# tag, number of vertices followed by list of associated vert
*edges,11,1,11,2,6,5,1,15,18,17,16,15  #  1
*edges,5,2,13,3,7,6  #  2
*edges,4,12,4,8,14  #  3
*edges,5,4,9,1,5,8  #  4
*edges,5,5,6,7,14,8  #  5
*edges,4,13,2,11,10  #  6
*edges,4,1,9,10,11  #  7
*edges,4,9,4,12,10  #  8
*edges,4,3,13,10,12  #  9
*edges,4,3,12,14,7  # 10
*edges,4,15,16,17,18  # 11
# 
# surf attributes:
#  surf name, surf position VERT/CEIL/FLOR/SLOP/UNKN
#  child of (surface name), useage (pair of tags) 
#  construction name, optical name
#  boundary condition tag followed by two data items
*surf,north,VERT,-,-,-,ext_wall,OPAQUE,EXTERIOR,0,0  #   1 ||< external
*surf,bed1,VERT,-,-,-,int_part,OPAQUE,ANOTHER,07,04  #   2 ||< bathrm:bed1
*surf,w_heat_c,VERT,-,-,-,int_part,OPAQUE,ANOTHER,08,04  #   3 ||< bathrm:w_heat_c
*surf,east,VERT,-,-,-,ext_part,OPAQUE,SIMILAR,00,00  #   4 ||< identical environment
*surf,loft,CEIL,-,-,-,loft_ceil,OPAQUE,ANOTHER,12,01  #   5 ||< bathrm:loft
*surf,porch,FLOR,-,-,-,upper_flor,OPAQUE,EXTERIOR,0,0  #   6 ||< external
*surf,bin_c,FLOR,-,-,-,upper_flor,OPAQUE,ANOTHER,01,05  #   7 ||< bathrm:bin_c
*surf,stairs,FLOR,-,-,-,upper_flor,OPAQUE,ANOTHER,02,05  #   8 ||< bathrm:stairs
*surf,hall_1,FLOR,-,-,-,upper_flor,OPAQUE,ANOTHER,03,07  #   9 ||< bathrm:hall_1
*surf,door_hall2,VERT,-,-,-,int_doors,OPAQUE,ANOTHER,09,01  #  10 ||< door_bath:hall_2
*surf,window,VERT,-,-,-,dbl_glz,DCF7365_10nb,EXTERIOR,0,0  #  11 ||< external
# 
*insol,3,0,0,0  # default insolation distribution
# 
# shading directives
*shad_calc,none  # no temporal shading requested
# 
*insol_calc,none  # no insolation requested
# 
*base_list,4,6,7,8,9,     6.00 0  # zone base list
