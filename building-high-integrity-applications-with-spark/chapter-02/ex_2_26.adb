with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

procedure ex_2_26 is
  generic
    type Component_Type is limited private;
    type Index_Type is (<>);
    type Array_Type is array (Index_Type range <>) of Component_Type;
    with function Selected (From_Source : in Component_Type;
                            Pattern     : in Component_Type) return Boolean;
  procedure Tally (source : in Array_Type; 
                   pattern : in Component_Type;
                   result : out Natural);

  procedure Tally (source : in Array_Type; 
                   pattern : in Component_Type;
                   result : out Natural) is
  begin
     Result := 0;
     for index in source'Range loop
        if selected (source (index), Pattern) then
           result := result + 1;
        end if;
     end loop;
  end Tally;

  type Point is
    record
      x_coord : Float;
      y_coord : Float;
    end record;

  function "<=" (left : in Point; right : in Point) return Boolean is
    left_squared : Float;
    right_squared : Float;
  begin
    left_squared := left.x_coord ** 2 + left.y_coord ** 2;
    right_squared := right.x_coord ** 2 + right.y_coord ** 2;
    return left_squared <= right_squared;
  end "<=";

  type Point_Array is Array (Natural range <>) of Point;
  subtype Point_List is Point_Array (101 .. 200);

  -- don't know of a smarter way to do this yet
  A0 : Point := (0.95241624, 0.32765597);
  A1 : Point := (0.4179777, 0.46487015);
  A2 : Point := (0.8130075, 0.79635316);
  A3 : Point := (0.22840846, 0.76257086);
  A4 : Point := (0.96096385, 0.94196856);
  A5 : Point := (0.29642212, 0.277102);
  A6 : Point := (0.5444932, 0.86257255);
  A7 : Point := (0.68640435, 0.5165605);
  A8 : Point := (0.4928624, 0.83818865);
  A9 : Point := (0.97407347, 0.4152642);
  A10 : Point := (0.880314, 0.7588412);
  A11 : Point := (0.9245343, 0.8382872);
  A12 : Point := (0.3298843, 0.0773868);
  A13 : Point := (0.47930753, 0.22493261);
  A14 : Point := (0.5522722, 0.3729118);
  A15 : Point := (0.12007642, 0.4885682);
  A16 : Point := (0.058832288, 0.96540725);
  A17 : Point := (0.2443915, 0.16070783);
  A18 : Point := (0.45778322, 0.789521);
  A19 : Point := (0.27638692, 0.07182139);
  A20 : Point := (0.77807707, 0.49355555);
  A21 : Point := (0.46577913, 0.9057632);
  A22 : Point := (0.78346527, 0.07424402);
  A23 : Point := (0.026220858, 0.69521034);
  A24 : Point := (0.8856122, 0.14854932);
  A25 : Point := (0.7077955, 0.57901806);
  A26 : Point := (0.7633006, 0.5767742);
  A27 : Point := (0.5695112, 0.89646);
  A28 : Point := (0.19658142, 0.72823834);
  A29 : Point := (0.5506461, 0.3160982);
  A30 : Point := (0.5600471, 0.3789025);
  A31 : Point := (0.07241738, 0.19730622);
  A32 : Point := (0.3462417, 0.4724499);
  A33 : Point := (0.92450404, 0.65966225);
  A34 : Point := (0.54471046, 0.7009489);
  A35 : Point := (0.89840287, 0.9295829);
  A36 : Point := (0.5485832, 0.7724178);
  A37 : Point := (0.2684993, 0.8753341);
  A38 : Point := (0.94127095, 0.050122023);
  A39 : Point := (0.24229413, 0.30223852);
  A40 : Point := (0.30133396, 0.9576048);
  A41 : Point := (0.806756, 0.5213981);
  A42 : Point := (0.40249074, 0.6452629);
  A43 : Point := (0.09472036, 0.030113935);
  A44 : Point := (0.5548371, 0.17533052);
  A45 : Point := (0.043191373, 0.34357625);
  A46 : Point := (0.5875116, 0.18465257);
  A47 : Point := (0.9770271, 0.2291007);
  A48 : Point := (0.19529444, 0.17646623);
  A49 : Point := (0.04261291, 0.84061974);
  A50 : Point := (0.22308439, 0.33704162);
  A51 : Point := (0.5557045, 0.6973409);
  A52 : Point := (0.43212795, 0.8995631);
  A53 : Point := (0.1877191, 0.6521152);
  A54 : Point := (0.44765562, 0.43078548);
  A55 : Point := (0.07056278, 0.1484158);
  A56 : Point := (0.82472056, 0.10612774);
  A57 : Point := (0.87992954, 0.25681472);
  A58 : Point := (0.4611687, 0.6919464);
  A59 : Point := (0.4923371, 0.44001114);
  A60 : Point := (0.2355529, 0.961365);
  A61 : Point := (0.08654076, 0.3379671);
  A62 : Point := (0.6333203, 0.03944844);
  A63 : Point := (0.4630952, 0.35033572);
  A64 : Point := (0.95476204, 0.37755477);
  A65 : Point := (0.7275249, 0.5715398);
  A66 : Point := (0.25914454, 0.88385034);
  A67 : Point := (0.36676943, 0.9946095);
  A68 : Point := (0.60540605, 0.1413356);
  A69 : Point := (0.64235765, 0.52388555);
  A70 : Point := (0.093182564, 0.5960256);
  A71 : Point := (0.32732874, 0.5452246);
  A72 : Point := (0.20922452, 0.33151644);
  A73 : Point := (0.28058314, 0.807321);
  A74 : Point := (0.64212483, 0.31301695);
  A75 : Point := (0.53855175, 0.52172476);
  A76 : Point := (0.9694459, 0.30064029);
  A77 : Point := (0.31939304, 0.6352512);
  A78 : Point := (0.95069885, 0.53055894);
  A79 : Point := (0.092057586, 0.55053437);
  A80 : Point := (0.91019654, 0.5413758);
  A81 : Point := (0.1273179, 0.4428838);
  A82 : Point := (0.27670622, 0.49523818);
  A83 : Point := (0.38919592, 0.15941054);
  A84 : Point := (0.50132763, 0.087913275);
  A85 : Point := (0.3651989, 0.29524493);
  A86 : Point := (0.6184973, 0.7539876);
  A87 : Point := (0.2975937, 0.86787784);
  A88 : Point := (0.79298204, 0.71289384);
  A89 : Point := (0.04392892, 0.39112043);
  A90 : Point := (0.5318024, 0.3445887);
  A91 : Point := (0.44460106, 0.56244695);
  A92 : Point := (0.38598102, 0.07200211);
  A93 : Point := (0.043021083, 0.089710474);
  A94 : Point := (0.052723765, 0.018080413);
  A95 : Point := (0.42757362, 0.9042056);
  A96 : Point := (0.7721195, 0.12120378);
  A97 : Point := (0.4348843, 0.53620034);
  A98 : Point := (0.8298228, 0.57245153);
  A99 : Point := (0.26487488, 0.30640996);
  A100 : Point := (0.19271564, 0.5857113);

  my_points : Point_List := (
    -- ok this works
    101 => (0.95241624, 0.32765597),
    102 => A1,
    103 => A2,
    104 => A3,
    105 => A4,
    106 => A5,
    107 => A6,
    108 => A7,
    109 => A8,
    110 => A9,
    111 => A10,
    112 => A11,
    113 => A12,
    114 => A13,
    115 => A14,
    116 => A15,
    117 => A16,
    118 => A17,
    119 => A18,
    120 => A19,
    121 => A20,
    122 => A21,
    123 => A22,
    124 => A23,
    125 => A24,
    126 => A25,
    127 => A26,
    128 => A27,
    129 => A28,
    130 => A29,
    131 => A30,
    132 => A31,
    133 => A32,
    134 => A33,
    135 => A34,
    136 => A35,
    137 => A36,
    138 => A37,
    139 => A38,
    140 => A39,
    141 => A40,
    142 => A41,
    143 => A42,
    144 => A43,
    145 => A44,
    146 => A45,
    147 => A46,
    148 => A47,
    149 => A48,
    150 => A49,
    151 => A50,
    152 => A51,
    153 => A52,
    154 => A53,
    155 => A54,
    156 => A55,
    157 => A56,
    158 => A57,
    159 => A58,
    160 => A59,
    161 => A60,
    162 => A61,
    163 => A62,
    164 => A63,
    165 => A64,
    166 => A65,
    167 => A66,
    168 => A67,
    169 => A68,
    170 => A69,
    171 => A70,
    172 => A71,
    173 => A72,
    174 => A73,
    175 => A74,
    176 => A75,
    177 => A76,
    178 => A77,
    179 => A78,
    180 => A79,
    181 => A80,
    182 => A81,
    183 => A82,
    184 => A83,
    185 => A84,
    186 => A85,
    187 => A86,
    188 => A87,
    189 => A88,
    190 => A89,
    191 => A90,
    192 => A91,
    193 => A92,
    194 => A93,
    195 => A94,
    196 => A95,
    197 => A96,
    198 => A97,
    199 => A98,
    200 => A99
  );

  procedure my_tally is new Tally(
    Component_Type => Point,
    Index_Type     => Natural,
    Array_type     => Point_Array,
    selected       => "<="
  );

  result : Natural;
begin
  -- using 0.5, 0.5 instead of 1.0, 1.0 as I've instantiated the points in a
  -- unit circle
  my_tally(my_points, (0.5, 0.5), result);
  put_line("result " & Natural'Image(result));
end ex_2_26;
