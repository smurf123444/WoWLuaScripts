local MAX_BAG = 255
local MAX_SLOT = 255
local DEADMINES_MYTHIC_LEVEL = "DEADMINES_MYTHIC_LEVEL" -- Replace with the appropriate value or key

local BUFFS = {
    [1] = 12345,
    [2] = 23456,
}

local DUNGEON_MAP_ID = 123 -- Replace with the ID of your dungeon map

local DEADMINES_NPC_LIST = {
    639,
}

local TIME_TIERS = {
    "PLATINUM",
    "GOLD",
    "SILVER",
    "BRONZE"
}

local CLASS_TIER_REWARDS = {
    [1] = {
    PLATINUM = {
        [1] = 10101, [2] = 10102, [3] = 10103, [4] = 10104, [5] = 10105, [6] = 10106, [7] = 10107, [8] = 10108, [9] = 10109,
        [10] = 10110, [11] = 10111, [12] = 10112, [13] = 10113, [14] = 10114, [15] = 10115, [16] = 10116, [17] = 10117,
        [18] = 10118, [19] = 10119, [20] = 10120, [21] = 10121, [22] = 10122, [23] = 10123, [24] = 10124, [25] = 10125,
        [26] = 10126, [27] = 10127, [28] = 10128, [29] = 10129, [30] = 10130,
    },
    GOLD = {
        [1] = 10201, [2] = 10202, [3] = 10203, [4] = 10204, [5] = 10205, [6] = 10206, [7] = 10207, [8] = 10208, [9] = 10209,
        [10] = 10210, [11] = 10211, [12] = 10212, [13] = 10213, [14] = 10214, [15] = 10215, [16] = 10216, [17] = 10217,
        [18] = 10218, [19] = 10219, [20] = 10220, [21] = 10221, [22] = 10222, [23] = 10223, [24] = 10224, [25] = 10225,
        [26] = 10226, [27] = 10227, [28] = 10228, [29] = 10229, [30] = 10230,
    },
    SILVER = {
        [1] = 10301, [2] = 10302, [3] = 10303, [4] = 10304, [5] = 10305, [6] = 10306, [7] = 10307, [8] = 10308, [9] = 10309,
        [10] = 10310, [11] = 10311, [12] = 10312, [13] = 10313, [14] = 10314, [15] = 10315, [16] = 10316, [17] = 10317,
        [18] = 10318, [19] = 10319, [20] = 10320, [21] = 10321, [22] = 10322, [23] = 10323, [24] = 10324, [25] = 10325,
        [26] = 10326, [27] = 10327, [28] = 10328, [29] = 10329, [30] = 10330,
    },
    BRONZE = {
        [1] = 10401, [2] = 10402, [3] = 10403, [4] = 10404, [5] = 10405, [6] = 10406, [7] = 10407, [8] = 10408, [9] = 10409,
        [10] = 10410, [11] = 10411, [12] = 10412, [13] = 10413, [14] = 10414, [15] = 10415, [16] = 10416, [17] = 10417,
        [18] = 10418, [19] = 10419, [20] = 10420, [21] = 10421, [22] = 10422, [23] = 10423, [24] = 10424, [25] = 10425,
        [26] = 10426, [27] = 10427, [28] = 10428, [29] = 10429, [30] = 10430,
    },
},
[2] = {
    PLATINUM = {
        [1] = 10101, [2] = 10102, [3] = 10103, [4] = 10104, [5] = 10105, [6] = 10106, [7] = 10107, [8] = 10108, [9] = 10109,
        [10] = 10110, [11] = 10111, [12] = 10112, [13] = 10113, [14] = 10114, [15] = 10115, [16] = 10116, [17] = 10117,
        [18] = 10118, [19] = 10119, [20] = 10120, [21] = 10121, [22] = 10122, [23] = 10123, [24] = 10124, [25] = 10125,
        [26] = 10126, [27] = 10127, [28] = 10128, [29] = 10129, [30] = 10130,
    },
    GOLD = {
        [1] = 10201, [2] = 10202, [3] = 10203, [4] = 10204, [5] = 10205, [6] = 10206, [7] = 10207, [8] = 10208, [9] = 10209,
        [10] = 10210, [11] = 10211, [12] = 10212, [13] = 10213, [14] = 10214, [15] = 10215, [16] = 10216, [17] = 10217,
        [18] = 10218, [19] = 10219, [20] = 10220, [21] = 10221, [22] = 10222, [23] = 10223, [24] = 10224, [25] = 10225,
        [26] = 10226, [27] = 10227, [28] = 10228, [29] = 10229, [30] = 10230,
    },
    SILVER = {
        [1] = 10301, [2] = 10302, [3] = 10303, [4] = 10304, [5] = 10305, [6] = 10306, [7] = 10307, [8] = 10308, [9] = 10309,
        [10] = 10310, [11] = 10311, [12] = 10312, [13] = 10313, [14] = 10314, [15] = 10315, [16] = 10316, [17] = 10317,
        [18] = 10318, [19] = 10319, [20] = 10320, [21] = 10321, [22] = 10322, [23] = 10323, [24] = 10324, [25] = 10325,
        [26] = 10326, [27] = 10327, [28] = 10328, [29] = 10329, [30] = 10330,
    },
    BRONZE = {
        [1] = 10401, [2] = 10402, [3] = 10403, [4] = 10404, [5] = 10405, [6] = 10406, [7] = 10407, [8] = 10408, [9] = 10409,
        [10] = 10410, [11] = 10411, [12] = 10412, [13] = 10413, [14] = 10414, [15] = 10415, [16] = 10416, [17] = 10417,
        [18] = 10418, [19] = 10419, [20] = 10420, [21] = 10421, [22] = 10422, [23] = 10423, [24] = 10424, [25] = 10425,
        [26] = 10426, [27] = 10427, [28] = 10428, [29] = 10429, [30] = 10430,
    },
},

[3] = {
    PLATINUM = {
        [1] = 10101, [2] = 10102, [3] = 10103, [4] = 10104, [5] = 10105, [6] = 10106, [7] = 10107, [8] = 10108, [9] = 10109,
        [10] = 10110, [11] = 10111, [12] = 10112, [13] = 10113, [14] = 10114, [15] = 10115, [16] = 10116, [17] = 10117,
        [18] = 10118, [19] = 10119, [20] = 10120, [21] = 10121, [22] = 10122, [23] = 10123, [24] = 10124, [25] = 10125,
        [26] = 10126, [27] = 10127, [28] = 10128, [29] = 10129, [30] = 10130,
    },
    GOLD = {
        [1] = 10201, [2] = 10202, [3] = 10203, [4] = 10204, [5] = 10205, [6] = 10206, [7] = 10207, [8] = 10208, [9] = 10209,
        [10] = 10210, [11] = 10211, [12] = 10212, [13] = 10213, [14] = 10214, [15] = 10215, [16] = 10216, [17] = 10217,
        [18] = 10218, [19] = 10219, [20] = 10220, [21] = 10221, [22] = 10222, [23] = 10223, [24] = 10224, [25] = 10225,
        [26] = 10226, [27] = 10227, [28] = 10228, [29] = 10229, [30] = 10230,
    },
    SILVER = {
        [1] = 10301, [2] = 10302, [3] = 10303, [4] = 10304, [5] = 10305, [6] = 10306, [7] = 10307, [8] = 10308, [9] = 10309,
        [10] = 10310, [11] = 10311, [12] = 10312, [13] = 10313, [14] = 10314, [15] = 10315, [16] = 10316, [17] = 10317,
        [18] = 10318, [19] = 10319, [20] = 10320, [21] = 10321, [22] = 10322, [23] = 10323, [24] = 10324, [25] = 10325,
        [26] = 10326, [27] = 10327, [28] = 10328, [29] = 10329, [30] = 10330,
    },
    BRONZE = {
        [1] = 10401, [2] = 10402, [3] = 10403, [4] = 10404, [5] = 10405, [6] = 10406, [7] = 10407, [8] = 10408, [9] = 10409,
        [10] = 10410, [11] = 10411, [12] = 10412, [13] = 10413, [14] = 10414, [15] = 10415, [16] = 10416, [17] = 10417,
        [18] = 10418, [19] = 10419, [20] = 10420, [21] = 10421, [22] = 10422, [23] = 10423, [24] = 10424, [25] = 10425,
        [26] = 10426, [27] = 10427, [28] = 10428, [29] = 10429, [30] = 10430,
    },
},

[4] = {
    PLATINUM = {
        [1] = 10101, [2] = 10102, [3] = 10103, [4] = 10104, [5] = 10105, [6] = 10106, [7] = 10107, [8] = 10108, [9] = 10109,
        [10] = 10110, [11] = 10111, [12] = 10112, [13] = 10113, [14] = 10114, [15] = 10115, [16] = 10116, [17] = 10117,
        [18] = 10118, [19] = 10119, [20] = 10120, [21] = 10121, [22] = 10122, [23] = 10123, [24] = 10124, [25] = 10125,
        [26] = 10126, [27] = 10127, [28] = 10128, [29] = 10129, [30] = 10130,
    },
    GOLD = {
        [1] = 10201, [2] = 10202, [3] = 10203, [4] = 10204, [5] = 10205, [6] = 10206, [7] = 10207, [8] = 10208, [9] = 10209,
        [10] = 10210, [11] = 10211, [12] = 10212, [13] = 10213, [14] = 10214, [15] = 10215, [16] = 10216, [17] = 10217,
        [18] = 10218, [19] = 10219, [20] = 10220, [21] = 10221, [22] = 10222, [23] = 10223, [24] = 10224, [25] = 10225,
        [26] = 10226, [27] = 10227, [28] = 10228, [29] = 10229, [30] = 10230,
    },
    SILVER = {
        [1] = 10301, [2] = 10302, [3] = 10303, [4] = 10304, [5] = 10305, [6] = 10306, [7] = 10307, [8] = 10308, [9] = 10309,
        [10] = 10310, [11] = 10311, [12] = 10312, [13] = 10313, [14] = 10314, [15] = 10315, [16] = 10316, [17] = 10317,
        [18] = 10318, [19] = 10319, [20] = 10320, [21] = 10321, [22] = 10322, [23] = 10323, [24] = 10324, [25] = 10325,
        [26] = 10326, [27] = 10327, [28] = 10328, [29] = 10329, [30] = 10330,
    },
    BRONZE = {
        [1] = 10401, [2] = 10402, [3] = 10403, [4] = 10404, [5] = 10405, [6] = 10406, [7] = 10407, [8] = 10408, [9] = 10409,
        [10] = 10410, [11] = 10411, [12] = 10412, [13] = 10413, [14] = 10414, [15] = 10415, [16] = 10416, [17] = 10417,
        [18] = 10418, [19] = 10419, [20] = 10420, [21] = 10421, [22] = 10422, [23] = 10423, [24] = 10424, [25] = 10425,
        [26] = 10426, [27] = 10427, [28] = 10428, [29] = 10429, [30] = 10430,
    },
},
[5] = {
    PLATINUM = {
        [1] = 10101, [2] = 10102, [3] = 10103, [4] = 10104, [5] = 10105, [6] = 10106, [7] = 10107, [8] = 10108, [9] = 10109,
        [10] = 10110, [11] = 10111, [12] = 10112, [13] = 10113, [14] = 10114, [15] = 10115, [16] = 10116, [17] = 10117,
        [18] = 10118, [19] = 10119, [20] = 10120, [21] = 10121, [22] = 10122, [23] = 10123, [24] = 10124, [25] = 10125,
        [26] = 10126, [27] = 10127, [28] = 10128, [29] = 10129, [30] = 10130,
    },
    GOLD = {
        [1] = 10201, [2] = 10202, [3] = 10203, [4] = 10204, [5] = 10205, [6] = 10206, [7] = 10207, [8] = 10208, [9] = 10209,
        [10] = 10210, [11] = 10211, [12] = 10212, [13] = 10213, [14] = 10214, [15] = 10215, [16] = 10216, [17] = 10217,
        [18] = 10218, [19] = 10219, [20] = 10220, [21] = 10221, [22] = 10222, [23] = 10223, [24] = 10224, [25] = 10225,
        [26] = 10226, [27] = 10227, [28] = 10228, [29] = 10229, [30] = 10230,
    },
    SILVER = {
        [1] = 10301, [2] = 10302, [3] = 10303, [4] = 10304, [5] = 10305, [6] = 10306, [7] = 10307, [8] = 10308, [9] = 10309,
        [10] = 10310, [11] = 10311, [12] = 10312, [13] = 10313, [14] = 10314, [15] = 10315, [16] = 10316, [17] = 10317,
        [18] = 10318, [19] = 10319, [20] = 10320, [21] = 10321, [22] = 10322, [23] = 10323, [24] = 10324, [25] = 10325,
        [26] = 10326, [27] = 10327, [28] = 10328, [29] = 10329, [30] = 10330,
    },
    BRONZE = {
        [1] = 10401, [2] = 10402, [3] = 10403, [4] = 10404, [5] = 10405, [6] = 10406, [7] = 10407, [8] = 10408, [9] = 10409,
        [10] = 10410, [11] = 10411, [12] = 10412, [13] = 10413, [14] = 10414, [15] = 10415, [16] = 10416, [17] = 10417,
        [18] = 10418, [19] = 10419, [20] = 10420, [21] = 10421, [22] = 10422, [23] = 10423, [24] = 10424, [25] = 10425,
        [26] = 10426, [27] = 10427, [28] = 10428, [29] = 10429, [30] = 10430,
    },
},

[6] = {
    PLATINUM = {
        [1] = 10101, [2] = 10102, [3] = 10103, [4] = 10104, [5] = 10105, [6] = 10106, [7] = 10107, [8] = 10108, [9] = 10109,
        [10] = 10110, [11] = 10111, [12] = 10112, [13] = 10113, [14] = 10114, [15] = 10115, [16] = 10116, [17] = 10117,
        [18] = 10118, [19] = 10119, [20] = 10120, [21] = 10121, [22] = 10122, [23] = 10123, [24] = 10124, [25] = 10125,
        [26] = 10126, [27] = 10127, [28] = 10128, [29] = 10129, [30] = 10130,
    },
    GOLD = {
        [1] = 10201, [2] = 10202, [3] = 10203, [4] = 10204, [5] = 10205, [6] = 10206, [7] = 10207, [8] = 10208, [9] = 10209,
        [10] = 10210, [11] = 10211, [12] = 10212, [13] = 10213, [14] = 10214, [15] = 10215, [16] = 10216, [17] = 10217,
        [18] = 10218, [19] = 10219, [20] = 10220, [21] = 10221, [22] = 10222, [23] = 10223, [24] = 10224, [25] = 10225,
        [26] = 10226, [27] = 10227, [28] = 10228, [29] = 10229, [30] = 10230,
    },
    SILVER = {
        [1] = 10301, [2] = 10302, [3] = 10303, [4] = 10304, [5] = 10305, [6] = 10306, [7] = 10307, [8] = 10308, [9] = 10309,
        [10] = 10310, [11] = 10311, [12] = 10312, [13] = 10313, [14] = 10314, [15] = 10315, [16] = 10316, [17] = 10317,
        [18] = 10318, [19] = 10319, [20] = 10320, [21] = 10321, [22] = 10322, [23] = 10323, [24] = 10324, [25] = 10325,
        [26] = 10326, [27] = 10327, [28] = 10328, [29] = 10329, [30] = 10330,
    },
    BRONZE = {
        [1] = 10401, [2] = 10402, [3] = 10403, [4] = 10404, [5] = 10405, [6] = 10406, [7] = 10407, [8] = 10408, [9] = 10409,
        [10] = 10410, [11] = 10411, [12] = 10412, [13] = 10413, [14] = 10414, [15] = 10415, [16] = 10416, [17] = 10417,
        [18] = 10418, [19] = 10419, [20] = 10420, [21] = 10421, [22] = 10422, [23] = 10423, [24] = 10424, [25] = 10425,
        [26] = 10426, [27] = 10427, [28] = 10428, [29] = 10429, [30] = 10430,
    },
},

[7] = {
    PLATINUM = {
        [1] = 10101, [2] = 10102, [3] = 10103, [4] = 10104, [5] = 10105, [6] = 10106, [7] = 10107, [8] = 10108, [9] = 10109,
        [10] = 10110, [11] = 10111, [12] = 10112, [13] = 10113, [14] = 10114, [15] = 10115, [16] = 10116, [17] = 10117,
        [18] = 10118, [19] = 10119, [20] = 10120, [21] = 10121, [22] = 10122, [23] = 10123, [24] = 10124, [25] = 10125,
        [26] = 10126, [27] = 10127, [28] = 10128, [29] = 10129, [30] = 10130,
    },
    GOLD = {
        [1] = 10201, [2] = 10202, [3] = 10203, [4] = 10204, [5] = 10205, [6] = 10206, [7] = 10207, [8] = 10208, [9] = 10209,
        [10] = 10210, [11] = 10211, [12] = 10212, [13] = 10213, [14] = 10214, [15] = 10215, [16] = 10216, [17] = 10217,
        [18] = 10218, [19] = 10219, [20] = 10220, [21] = 10221, [22] = 10222, [23] = 10223, [24] = 10224, [25] = 10225,
        [26] = 10226, [27] = 10227, [28] = 10228, [29] = 10229, [30] = 10230,
    },
    SILVER = {
        [1] = 10301, [2] = 10302, [3] = 10303, [4] = 10304, [5] = 10305, [6] = 10306, [7] = 10307, [8] = 10308, [9] = 10309,
        [10] = 10310, [11] = 10311, [12] = 10312, [13] = 10313, [14] = 10314, [15] = 10315, [16] = 10316, [17] = 10317,
        [18] = 10318, [19] = 10319, [20] = 10320, [21] = 10321, [22] = 10322, [23] = 10323, [24] = 10324, [25] = 10325,
        [26] = 10326, [27] = 10327, [28] = 10328, [29] = 10329, [30] = 10330,
    },
    BRONZE = {
        [1] = 10401, [2] = 10402, [3] = 10403, [4] = 10404, [5] = 10405, [6] = 10406, [7] = 10407, [8] = 10408, [9] = 10409,
        [10] = 10410, [11] = 10411, [12] = 10412, [13] = 10413, [14] = 10414, [15] = 10415, [16] = 10416, [17] = 10417,
        [18] = 10418, [19] = 10419, [20] = 10420, [21] = 10421, [22] = 10422, [23] = 10423, [24] = 10424, [25] = 10425,
        [26] = 10426, [27] = 10427, [28] = 10428, [29] = 10429, [30] = 10430,
    },
},

[8] = {
    PLATINUM = {
        [1] = 10101, [2] = 10102, [3] = 10103, [4] = 10104, [5] = 10105, [6] = 10106, [7] = 10107, [8] = 10108, [9] = 10109,
        [10] = 10110, [11] = 10111, [12] = 10112, [13] = 10113, [14] = 10114, [15] = 10115, [16] = 10116, [17] = 10117,
        [18] = 10118, [19] = 10119, [20] = 10120, [21] = 10121, [22] = 10122, [23] = 10123, [24] = 10124, [25] = 10125,
        [26] = 10126, [27] = 10127, [28] = 10128, [29] = 10129, [30] = 10130,
    },
    GOLD = {
        [1] = 10201, [2] = 10202, [3] = 10203, [4] = 10204, [5] = 10205, [6] = 10206, [7] = 10207, [8] = 10208, [9] = 10209,
        [10] = 10210, [11] = 10211, [12] = 10212, [13] = 10213, [14] = 10214, [15] = 10215, [16] = 10216, [17] = 10217,
        [18] = 10218, [19] = 10219, [20] = 10220, [21] = 10221, [22] = 10222, [23] = 10223, [24] = 10224, [25] = 10225,
        [26] = 10226, [27] = 10227, [28] = 10228, [29] = 10229, [30] = 10230,
    },
    SILVER = {
        [1] = 10301, [2] = 10302, [3] = 10303, [4] = 10304, [5] = 10305, [6] = 10306, [7] = 10307, [8] = 10308, [9] = 10309,
        [10] = 10310, [11] = 10311, [12] = 10312, [13] = 10313, [14] = 10314, [15] = 10315, [16] = 10316, [17] = 10317,
        [18] = 10318, [19] = 10319, [20] = 10320, [21] = 10321, [22] = 10322, [23] = 10323, [24] = 10324, [25] = 10325,
        [26] = 10326, [27] = 10327, [28] = 10328, [29] = 10329, [30] = 10330,
    },
    BRONZE = {
        [1] = 10401, [2] = 10402, [3] = 10403, [4] = 10404, [5] = 10405, [6] = 10406, [7] = 10407, [8] = 10408, [9] = 10409,
        [10] = 10410, [11] = 10411, [12] = 10412, [13] = 10413, [14] = 10414, [15] = 10415, [16] = 10416, [17] = 10417,
        [18] = 10418, [19] = 10419, [20] = 10420, [21] = 10421, [22] = 10422, [23] = 10423, [24] = 10424, [25] = 10425,
        [26] = 10426, [27] = 10427, [28] = 10428, [29] = 10429, [30] = 10430,
    },
},

[9] = {
    PLATINUM = {
        [1] = 10101, [2] = 10102, [3] = 10103, [4] = 10104, [5] = 10105, [6] = 10106, [7] = 10107, [8] = 10108, [9] = 10109,
        [10] = 10110, [11] = 10111, [12] = 10112, [13] = 10113, [14] = 10114, [15] = 10115, [16] = 10116, [17] = 10117,
        [18] = 10118, [19] = 10119, [20] = 10120, [21] = 10121, [22] = 10122, [23] = 10123, [24] = 10124, [25] = 10125,
        [26] = 10126, [27] = 10127, [28] = 10128, [29] = 10129, [30] = 10130,
    },
    GOLD = {
        [1] = 10201, [2] = 10202, [3] = 10203, [4] = 10204, [5] = 10205, [6] = 10206, [7] = 10207, [8] = 10208, [9] = 10209,
        [10] = 10210, [11] = 10211, [12] = 10212, [13] = 10213, [14] = 10214, [15] = 10215, [16] = 10216, [17] = 10217,
        [18] = 10218, [19] = 10219, [20] = 10220, [21] = 10221, [22] = 10222, [23] = 10223, [24] = 10224, [25] = 10225,
        [26] = 10226, [27] = 10227, [28] = 10228, [29] = 10229, [30] = 10230,
    },
    SILVER = {
        [1] = 10301, [2] = 10302, [3] = 10303, [4] = 10304, [5] = 10305, [6] = 10306, [7] = 10307, [8] = 10308, [9] = 10309,
        [10] = 10310, [11] = 10311, [12] = 10312, [13] = 10313, [14] = 10314, [15] = 10315, [16] = 10316, [17] = 10317,
        [18] = 10318, [19] = 10319, [20] = 10320, [21] = 10321, [22] = 10322, [23] = 10323, [24] = 10324, [25] = 10325,
        [26] = 10326, [27] = 10327, [28] = 10328, [29] = 10329, [30] = 10330,
    },
    BRONZE = {
        [1] = 10401, [2] = 10402, [3] = 10403, [4] = 10404, [5] = 10405, [6] = 10406, [7] = 10407, [8] = 10408, [9] = 10409,
        [10] = 10410, [11] = 10411, [12] = 10412, [13] = 10413, [14] = 10414, [15] = 10415, [16] = 10416, [17] = 10417,
        [18] = 10418, [19] = 10419, [20] = 10420, [21] = 10421, [22] = 10422, [23] = 10423, [24] = 10424, [25] = 10425,
        [26] = 10426, [27] = 10427, [28] = 10428, [29] = 10429, [30] = 10430,
    },
},

[10] = {
    PLATINUM = {
        [1] = 10101, [2] = 10102, [3] = 10103, [4] = 10104, [5] = 10105, [6] = 10106, [7] = 10107, [8] = 10108, [9] = 10109,
        [10] = 10110, [11] = 10111, [12] = 10112, [13] = 10113, [14] = 10114, [15] = 10115, [16] = 10116, [17] = 10117,
        [18] = 10118, [19] = 10119, [20] = 10120, [21] = 10121, [22] = 10122, [23] = 10123, [24] = 10124, [25] = 10125,
        [26] = 10126, [27] = 10127, [28] = 10128, [29] = 10129, [30] = 10130,
    },
    GOLD = {
        [1] = 10201, [2] = 10202, [3] = 10203, [4] = 10204, [5] = 10205, [6] = 10206, [7] = 10207, [8] = 10208, [9] = 10209,
        [10] = 10210, [11] = 10211, [12] = 10212, [13] = 10213, [14] = 10214, [15] = 10215, [16] = 10216, [17] = 10217,
        [18] = 10218, [19] = 10219, [20] = 10220, [21] = 10221, [22] = 10222, [23] = 10223, [24] = 10224, [25] = 10225,
        [26] = 10226, [27] = 10227, [28] = 10228, [29] = 10229, [30] = 10230,
    },
    SILVER = {
        [1] = 10301, [2] = 10302, [3] = 10303, [4] = 10304, [5] = 10305, [6] = 10306, [7] = 10307, [8] = 10308, [9] = 10309,
        [10] = 10310, [11] = 10311, [12] = 10312, [13] = 10313, [14] = 10314, [15] = 10315, [16] = 10316, [17] = 10317,
        [18] = 10318, [19] = 10319, [20] = 10320, [21] = 10321, [22] = 10322, [23] = 10323, [24] = 10324, [25] = 10325,
        [26] = 10326, [27] = 10327, [28] = 10328, [29] = 10329, [30] = 10330,
    },
    BRONZE = {
        [1] = 10401, [2] = 10402, [3] = 10403, [4] = 10404, [5] = 10405, [6] = 10406, [7] = 10407, [8] = 10408, [9] = 10409,
        [10] = 10410, [11] = 10411, [12] = 10412, [13] = 10413, [14] = 10414, [15] = 10415, [16] = 10416, [17] = 10417,
        [18] = 10418, [19] = 10419, [20] = 10420, [21] = 10421, [22] = 10422, [23] = 10423, [24] = 10424, [25] = 10425,
        [26] = 10426, [27] = 10427, [28] = 10428, [29] = 10429, [30] = 10430,
    },
},

[11] = {
    PLATINUM = {
        [1] = 10101, [2] = 10102, [3] = 10103, [4] = 10104, [5] = 10105, [6] = 10106, [7] = 10107, [8] = 10108, [9] = 10109,
        [10] = 10110, [11] = 10111, [12] = 10112, [13] = 10113, [14] = 10114, [15] = 10115, [16] = 10116, [17] = 10117,
        [18] = 10118, [19] = 10119, [20] = 10120, [21] = 10121, [22] = 10122, [23] = 10123, [24] = 10124, [25] = 10125,
        [26] = 10126, [27] = 10127, [28] = 10128, [29] = 10129, [30] = 10130,
    },
    GOLD = {
        [1] = 10201, [2] = 10202, [3] = 10203, [4] = 10204, [5] = 10205, [6] = 10206, [7] = 10207, [8] = 10208, [9] = 10209,
        [10] = 10210, [11] = 10211, [12] = 10212, [13] = 10213, [14] = 10214, [15] = 10215, [16] = 10216, [17] = 10217,
        [18] = 10218, [19] = 10219, [20] = 10220, [21] = 10221, [22] = 10222, [23] = 10223, [24] = 10224, [25] = 10225,
        [26] = 10226, [27] = 10227, [28] = 10228, [29] = 10229, [30] = 10230,
    },
    SILVER = {
        [1] = 10301, [2] = 10302, [3] = 10303, [4] = 10304, [5] = 10305, [6] = 10306, [7] = 10307, [8] = 10308, [9] = 10309,
        [10] = 10310, [11] = 10311, [12] = 10312, [13] = 10313, [14] = 10314, [15] = 10315, [16] = 10316, [17] = 10317,
        [18] = 10318, [19] = 10319, [20] = 10320, [21] = 10321, [22] = 10322, [23] = 10323, [24] = 10324, [25] = 10325,
        [26] = 10326, [27] = 10327, [28] = 10328, [29] = 10329, [30] = 10330,
    },
    BRONZE = {
        [1] = 10401, [2] = 10402, [3] = 10403, [4] = 10404, [5] = 10405, [6] = 10406, [7] = 10407, [8] = 10408, [9] = 10409,
        [10] = 10410, [11] = 10411, [12] = 10412, [13] = 10413, [14] = 10414, [15] = 10415, [16] = 10416, [17] = 10417,
        [18] = 10418, [19] = 10419, [20] = 10420, [21] = 10421, [22] = 10422, [23] = 10423, [24] = 10424, [25] = 10425,
        [26] = 10426, [27] = 10427, [28] = 10428, [29] = 10429, [30] = 10430,
    },
},

[12] = {
    PLATINUM = {
        [1] = 10101, [2] = 10102, [3] = 10103, [4] = 10104, [5] = 10105, [6] = 10106, [7] = 10107, [8] = 10108, [9] = 10109,
        [10] = 10110, [11] = 10111, [12] = 10112, [13] = 10113, [14] = 10114, [15] = 10115, [16] = 10116, [17] = 10117,
        [18] = 10118, [19] = 10119, [20] = 10120, [21] = 10121, [22] = 10122, [23] = 10123, [24] = 10124, [25] = 10125,
        [26] = 10126, [27] = 10127, [28] = 10128, [29] = 10129, [30] = 10130,
    },
    GOLD = {
        [1] = 10201, [2] = 10202, [3] = 10203, [4] = 10204, [5] = 10205, [6] = 10206, [7] = 10207, [8] = 10208, [9] = 10209,
        [10] = 10210, [11] = 10211, [12] = 10212, [13] = 10213, [14] = 10214, [15] = 10215, [16] = 10216, [17] = 10217,
        [18] = 10218, [19] = 10219, [20] = 10220, [21] = 10221, [22] = 10222, [23] = 10223, [24] = 10224, [25] = 10225,
        [26] = 10226, [27] = 10227, [28] = 10228, [29] = 10229, [30] = 10230,
    },
    SILVER = {
        [1] = 10301, [2] = 10302, [3] = 10303, [4] = 10304, [5] = 10305, [6] = 10306, [7] = 10307, [8] = 10308, [9] = 10309,
        [10] = 10310, [11] = 10311, [12] = 10312, [13] = 10313, [14] = 10314, [15] = 10315, [16] = 10316, [17] = 10317,
        [18] = 10318, [19] = 10319, [20] = 10320, [21] = 10321, [22] = 10322, [23] = 10323, [24] = 10324, [25] = 10325,
        [26] = 10326, [27] = 10327, [28] = 10328, [29] = 10329, [30] = 10330,
    },
    BRONZE = {
        [1] = 10401, [2] = 10402, [3] = 10403, [4] = 10404, [5] = 10405, [6] = 10406, [7] = 10407, [8] = 10408, [9] = 10409,
        [10] = 10410, [11] = 10411, [12] = 10412, [13] = 10413, [14] = 10414, [15] = 10415, [16] = 10416, [17] = 10417,
        [18] = 10418, [19] = 10419, [20] = 10420, [21] = 10421, [22] = 10422, [23] = 10423, [24] = 10424, [25] = 10425,
        [26] = 10426, [27] = 10427, [28] = 10428, [29] = 10429, [30] = 10430,
    },
},

}

local function GetRewardForClass(playerClass, tier, mythicLevel)
    if not playerClass or not tier or not mythicLevel then
        print("Debug: One or more input parameters are nil. PlayerClass:", playerClass, "Tier:", tier, "MythicLevel:",
            mythicLevel)
        return nil
    end

    local classRewards = CLASS_TIER_REWARDS[playerClass]
    if not classRewards then
        print("Warning: No rewards found for class:", playerClass)
        print("Debug: Current CLASS_TIER_REWARDS table:", CLASS_TIER_REWARDS)
        return nil
    end

    local tierRewards = classRewards[tier]
    if not tierRewards or not tierRewards[mythicLevel] then
        print("Warning: No rewards found for class", playerClass, "tier:", tier, "and mythic level:", mythicLevel)
        print("Debug: Current rewards for class:", classRewards)
        print("Debug: Current rewards for tier:", tierRewards)
        return nil
    end

    print("Debug: Reward fetched for PlayerClass:", playerClass, "Tier:", tier, "MythicLevel:", mythicLevel, "Reward:",
        tierRewards[mythicLevel])
    return tierRewards[mythicLevel]
end

local function GetPlayerClass(player)
    -- Assuming this function exists and returns an integer representing the player's class
    return player:GetClass()
end

-- Create the array of mythic keystone entries.
local function CreateKeystoneEntries()
    local entries = {}
    for i = 0, 29 do
        table.insert(entries, 90000 + i)
    end
    return entries
end

local MYTHIC_KEYSTONE_ENTRIES = CreateKeystoneEntries()

-- Define the Mythic Level definitions.
local function CreateMythicTable()
    local tbl = { [0] = { healthMultiplier = 1, levelAddition = 0, damageMultiplier = 1 } }
    for i = 1, 30 do
        tbl[i] = {
            healthMultiplier = 1 + i * 0.2,
            levelAddition = i * 2,
            powerMultiplier = 1 + i * 0.2
        }
    end
    return tbl
end
local function OnPlayerDeath(event, player)
    local penalty = 5
    local existingPenalty = player:GetData("DeathPenalty") or 0
    player:SetData("DeathPenalty", existingPenalty + penalty)
    player:SendBroadcastMessage(string.format("5 seconds penalty added. Total penalty: %d seconds.",
        player:GetData("DeathPenalty")))
end

local MYTHIC_TABLE = CreateMythicTable()

-- Update player's mythic level based on the keystone in their bag
local function SetMythicLevelFromItem(player)
    for bag = 0, MAX_BAG do
        for slot = 0, MAX_SLOT do
            local item = player:GetItemByPos(bag, slot)
            if item then
                for i, keystoneEntry in ipairs(MYTHIC_KEYSTONE_ENTRIES) do
                    if item:GetEntry() == keystoneEntry then
                        player:SetUInt32Value(DEADMINES_MYTHIC_LEVEL, i) -- Set to the index
                        player:SendBroadcastMessage("Your mythic level has been set to Mythic+" .. (i) .. ".")
                        return
                    end
                end
            end
        end
    end
    player:SendBroadcastMessage("Mythic Keystone not found in your bags!")
end

-- Adjust NPC attributes when combat starts
local function OnCreatureEnterCombat(event, creature, target)
    local range = 100
    local players = creature:GetPlayersInRange(range)
    local highestMythicLevel = 0

    for _, player in ipairs(players) do
        local playerMythicLevel = player:GetUInt32Value(DEADMINES_MYTHIC_LEVEL)
        if playerMythicLevel > highestMythicLevel then
            highestMythicLevel = playerMythicLevel
        end
    end

    if not creature:GetData("OriginalMaxHealth") then
        creature:SetData("OriginalMaxHealth", creature:GetMaxHealth())
        creature:SetData("OriginalLevel", creature:GetLevel())
    end

    if not creature:GetData("MythicBuffed") or (highestMythicLevel > creature:GetData("MythicBuffedLevel")) then
        if MYTHIC_TABLE[highestMythicLevel] then
            local originalHealth = creature:GetData("OriginalMaxHealth")
            local originalLevel = creature:GetData("OriginalLevel")

            creature:SetMaxHealth(originalHealth * MYTHIC_TABLE[highestMythicLevel].healthMultiplier)
            creature:SetLevel(originalLevel + MYTHIC_TABLE[highestMythicLevel].levelAddition)
            creature:SetData("MythicBuffed", true)
            creature:SetData("MythicBuffedLevel", highestMythicLevel)

            local newHealth = creature:GetMaxHealth()
            creature:SetHealth(newHealth)

            if BUFFS[highestMythicLevel] then
                creature:CastSpell(creature, BUFFS[highestMythicLevel], true)
            end
        end
    end
end

-- Call this function when the dungeon starts
local function StartDungeonTimer(player)
    -- Check if a start time already exists for the player
    local existingStartTime = player:GetData("DungeonStartTime")
    if existingStartTime then
        player:SendBroadcastMessage("Dungeon timer is already running!")
        return -- Exit the function early if a timer is already running
    end
    player:SetData("DungeonStartTime", os.time())
    player:SendBroadcastMessage("The timer for the dungeon has started!")
end

-- This function checks if a player has already received a weekly reward
local function HasReceivedWeeklyReward(player)
    local result = CharDBQuery("SELECT highest_level FROM mythic_weekly_progress WHERE player_id = " ..
        player:GetGUIDLow() .. " AND YEARWEEK(week_start_date, 1) = YEARWEEK(CURDATE(), 1)")
    if result then
        local lastRewardedLevel = result:GetUInt32(0)
        return true, lastRewardedLevel
    end
    return false, nil
end

local function SetReceivedWeeklyReward(player, rewardID, mythicLevel, startTime)
    local startDate = os.date('%Y-%m-%d', startTime)
    CharDBExecute(
        "INSERT INTO mythic_weekly_progress (player_id, highest_level, week_start_date, reward_date, reward_id) VALUES (" ..
        player:GetGUIDLow() ..
        ", " ..
        mythicLevel ..
        ", '" ..
        startDate ..
        "', CURDATE(), " ..
        rewardID ..
        ") ON DUPLICATE KEY UPDATE reward_id = " ..
        rewardID .. ", reward_date = CURDATE(), highest_level = GREATEST(highest_level, " .. mythicLevel .. ")")
end

local function UpdatePlayerMythicLevelInSQL(player, newKeyLevel)
    CharDBExecute("UPDATE mythic_weekly_progress SET highest_level = " ..
    newKeyLevel - 1 .. " WHERE player_id = " .. player:GetGUIDLow())
end

local function EndDungeonTimer(creature)
    -- Ensure all constants are present
    if not TIME_TIERS or not CLASS_TIER_REWARDS or not MYTHIC_KEYSTONE_ENTRIES or not DEADMINES_MYTHIC_LEVEL then
        return
    end

    local range = 100
    local players = creature:GetPlayersInRange(range)

    for _, player in ipairs(players) do
        local success, message = pcall(function()
            local startTime = player:GetData("DungeonStartTime")
            local endTime = player:GetData("DungeonEndTime")
            local playerMythicLevel = player:GetUInt32Value(DEADMINES_MYTHIC_LEVEL)

            if not startTime then
                return
            end

            if endTime then
                player:SendBroadcastMessage("You have already completed this dungeon run and received your rewards.")
                return
            end

            player:SetData("DungeonEndTime", os.time())
            local deathPenalty = player:GetData("DeathPenalty") or 0
            local elapsedTime = (player:GetData("DungeonEndTime") - startTime) + deathPenalty
            local tier = nil

            -- Determine tier
            for key, time in pairs(TIME_TIERS) do
                if elapsedTime <= time then
                    tier = key
                    break
                end
            end

            local playerClass = GetPlayerClass(player)
            local award = GetRewardForClass(playerClass, tier, playerMythicLevel)

            local hasReceivedReward, lastRewardedLevel = HasReceivedWeeklyReward(player)

            if hasReceivedReward and lastRewardedLevel >= playerMythicLevel then
                player:SendBroadcastMessage(
                    "You have already received a reward for this level or a higher level this week.")
                return
            end

            if award then
                player:AddItem(award, 1)
                SetReceivedWeeklyReward(player, award, playerMythicLevel, startTime)
                player:SendBroadcastMessage(
                "Congratulations! You've been awarded for your performance. Check your inventory!")
            else
                player:SendBroadcastMessage("You didn't finish in time for a reward. Better luck next time!")
                playerMythicLevel = math.max(1, playerMythicLevel - 1) -- Decrease and ensure it doesn't go below 1
                player:SetUInt32Value(DEADMINES_MYTHIC_LEVEL, playerMythicLevel)
                player:SendBroadcastMessage("Your Mythic Level has been decreased to " .. playerMythicLevel .. ".")
            end

            -- Upgrade system based on tier
            local upgradeAmounts = {
                PLATINUM = 4,
                GOLD = 3,
                SILVER = 2,
                BRONZE = 1
            }

            local newKeyLevel = playerMythicLevel + (upgradeAmounts[tier] or 0)
            newKeyLevel = math.min(30, newKeyLevel) -- Ensure it doesn't exceed 30

            if newKeyLevel > playerMythicLevel then
                for bag = 0, MAX_BAG or 4 do
                    for slot = 0, MAX_SLOT or 32 do
                        local item = player:GetItemByPos(bag, slot)
                        if item and item:GetEntry() == MYTHIC_KEYSTONE_ENTRIES[playerMythicLevel] then
                            player:RemoveItem(item, 1)
                            player:AddItem(MYTHIC_KEYSTONE_ENTRIES[newKeyLevel], 1)
                            player:SetUInt32Value(DEADMINES_MYTHIC_LEVEL, newKeyLevel)
                            UpdatePlayerMythicLevelInSQL(player, newKeyLevel)
                            player:SendBroadcastMessage("Your Mythic Keystone has been upgraded to level " .. newKeyLevel)
                            break
                        end
                    end
                end
            end

            -- Reset the timer
            player:SetData("DungeonStartTime", nil)
            player:SetData("DungeonEndTime", nil)
        end)

        if not success and message then
            print("Error processing EndDungeonTimer for player " .. player:GetName() .. ": " .. message)
        end
    end
end


local function OnFinalBossDeath(event, creature)
    EndDungeonTimer(creature)
end

function CheckArea(event, player, newArea)
    if player:GetMapId() == DUNGEON_MAP_ID then -- assuming that you meant to compare with DUNGEON_MAP_ID
        -- If the player has already entered the dungeon, don't run the code again
        if not player:GetData("EnteredDungeon") then
            player:SetData("EnteredDungeon", true)
            StartDungeonTimer(player)
            SetMythicLevelFromItem(player)
        end
    else
        -- If the player is outside of the dungeon, reset the flag
        player:SetData("EnteredDungeon", false)
    end
end

local function CheckDungeonTimeHandler(event, player, command)
    if command == "dungeontime" then
        local startTime = player:GetData("DungeonStartTime")
        local endTime = player:GetData("DungeonEndTime")
        if not startTime then
            player:SendBroadcastMessage("You have not started a dungeon timer yet.")
            return false
        end
        if endTime then
            player:SendBroadcastMessage("You have already completed this dungeon run.")
            return false
        end
        local elapsedTime = os.time() - startTime
        local hours = math.floor(elapsedTime / 3600)
        local minutes = math.floor((elapsedTime % 3600) / 60)
        local seconds = elapsedTime % 60
        player:SendBroadcastMessage(string.format("Dungeon Timer: %02d:%02d:%02d", hours, minutes, seconds))
        return false
    end
end

RegisterPlayerEvent(6, OnPlayerDeath)                           -- 6 is the event code for PLAYER_EVENT_ON_DIE.
RegisterPlayerEvent(42, CheckDungeonTimeHandler)                -- COMMAND FOR TIMER
RegisterPlayerEvent(27, CheckArea)                              -- AREA CHECK FOR MYTHIC LEVEL SCAN
RegisterCreatureEvent(639, 4, OnFinalBossDeath)                 -- FINAL BOSS REWARD FOR ENDGAME
for _, creatureId in ipairs(DEADMINES_NPC_LIST) do
    RegisterCreatureEvent(creatureId, 1, OnCreatureEnterCombat) -- CREATURE BUFFS HEALTH LEVEL CHANGE
end