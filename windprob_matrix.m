function wind_matrix=windprob_matrix()
wind_matrix=zeros(3,3); %a window matrix to store the value of the wind in the neighbourhood of the specified cell
thetas=[45,0,45;90,0,90;135,180,135]; 

    function pw=pw_for_each_cell(theta)
    c1=0.045;
    c2=0.131; %these two constants are evaluated by applying least regression on experimental data
    windspeed= 3.78; %this value has been calculated by evaluating the mean of the values of the windspeed in the dataset
    theta_rad=deg2rad(theta);
    pw=exp(c1*windspeed)*exp(windspeed*c2*(cos(theta_rad)-1));
    end

for i=1:3
    for j=1:3
        wind_matrix(i,j)= pw_for_each_cell(thetas(i,j));
    end
end
wind_matrix(1,1)=0;
end
