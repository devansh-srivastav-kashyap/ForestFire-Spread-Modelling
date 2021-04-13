function p_burn_matrix=prob_burn(main_i,main_j,prob_veg,slope)

prob_in_equib=0.00058;
a=0.078;
s=1;
prob_wind=windprob_matrix();
p_burn_matrix=ones(3,3);
for i=1:3
    for j=1:3
        prob_slope=exp(a*slope(main_i,main_j,s));
        p_burn_matrix(i,j)= prob_in_equib*(1 + prob_veg(main_i,main_j))*prob_wind(i,j)*prob_slope;
        s=s+1;
    end
end

end