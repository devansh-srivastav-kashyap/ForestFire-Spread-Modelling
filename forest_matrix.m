function [forest,prob_veg]=forest_matrix(ignit_x,ignit_y,forest) 
for i=1:372
        for j=1:372
            %% Create forest and Vegetation Probability Matrix
            if forest(i,j)==6||forest(i,j)==7||forest(i,j)==8||forest(i,j)==9||forest(i,j)==11||forest(i,j)==17||forest(i,j)==18||forest(i,j)==0||forest(i,j)==127
                forest(i,j)=1;
            else
                 forest(i,j)=2;
            end
            %Probabilty Matrix
                switch(forest(i,j))
                    case 1
                         prob_veg(i,j)=0.702;
                    case 2
                         prob_veg(i,j)=0.3;
                    case 3
                         prob_veg(i,j)=0.5;
                    case 4
                         prob_veg(i,j)=0.887;
                    case 6
                         prob_veg(i,j)=0;
                    case 7
                         prob_veg(i,j)=0;
                    case 10
                         prob_veg(i,j)=0.09;
                    case 14
                         prob_veg(i,j)=0.09;
                    case 15
                         prob_veg(i,j)=0.5;
                    otherwise
                         prob_veg(i,j)=0;
                 end
         
         %Ignite the grid
           forest(ignit_x,ignit_y)=3;
        end
    end