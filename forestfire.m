function out=forestfire(ignit_x,ignit_y)

if ignit_x>277
    error('Coordinate out of Map');
end
 %%import all the data 
    %Forest and Vegetation
        forest1=GEOTIFF_READ('updated_veg_uttara.tif');
        forest2=forest1.z;
        forest2(277:372,1:372)=1;
        
    %Altitude
        altitude_matrix_construct=GEOTIFF_READ('updated_alt_uttara.tif');
        altitude_matrix2=altitude_matrix_construct.z;
        altitude_matrix2(277:372,1:372)=1;
        altitude_matrix= altitude_matrix2;

        row=372;
        col=372;
    %make boundary as no fuel
        forest(1,:)=1;
        forest(:,1)=1;
        forest(row,:)=1; 
        forest(:,col)=1;
        
%% Define forest matrix and vegetation probabilty matrix
[forest,prob_veg]=forest_matrix(ignit_x,ignit_y,forest2);

%%
new_forest=forest;
gen=1; iterations=500; 
      while gen<iterations
       gen
       
          for i=1:row
            for j=1:col
                %% Create Slope window(denoted by slope_matrix) for each grid in forest map 
                   window=[0,0,0;0,0,0;0,0,0];
                    if i==1 || i==row || j==1 || j==col
                        s=1;
                    for k=1:3
                        for l=1:3
                        slope_matrix(i,j,s)=window(k,l);
                            s=s+1;
                        end
                    end
                    new_forest(i,j)=forest(i,j);
                    continue
                    end
                    current_height=altitude_matrix(i,j);
                    window(1,1)=atand(double(current_height-altitude_matrix(i-1,j-1)/1.414));
                    window(1,2)=atand(double(current_height-altitude_matrix(i-1,j)));
                    window(1,3)=atand(double(current_height-altitude_matrix(i-1,j+1)/1.414));
                    window(2,1)=atand(double(current_height-altitude_matrix(i,j-1)));
                    window(2,2)=0;
                    window(2,3)=atand(double(current_height-altitude_matrix(i,j+1)));
                    window(3,1)=atand(double(current_height-altitude_matrix(i+1,j-1)/1.414));
                    window(3,2)=atand(double(current_height-altitude_matrix(i+1,j)));
                    window(3,3)=atand(double(current_height-altitude_matrix(i+1,j+1)/1.414));
                    s=1;
                    for k=1:3
                        for l=1:3
                            slope_matrix(i,j,s)=window(k,l);
                            s=s+1;
                        end
                    end
         
                    %%Update the forest by following the CA Rule
                    old_forest=forest;
                    if i==1 || i==372 || j==1 || j==372
                       continue
                    end
                    if old_forest(i,j)==1 || old_forest(i,j)==4
                        new_forest(i,j)=old_forest(i,j);
                    end
        
                    if old_forest(i,j)==3 
                     
                        p_burn_matrix=prob_burn(i,j,prob_veg,slope_matrix); %p_burn_matrix is a 3x3 matrix storing the probabilty of neighbourhood fo getting burnt 
                        p_thresh=0.35;
                        if p_burn_matrix(1,1)>p_thresh
                            if old_forest(i-1,j-1)~=1 && old_forest(i-1,j-1)~=4
                                new_forest(i-1,j-1)=3;
                            end
                        end
                        if p_burn_matrix(1,2)>p_thresh
                            if old_forest(i-1,j)~=1 && old_forest(i-1,j)~=4
                                new_forest(i-1,j)=3;
                            end
                        end
                        if p_burn_matrix(1,3)>p_thresh
                             if old_forest(i-1,j+1)~=1 &&old_forest(i-1,j+1)~=4 
                                new_forest(i-1,j+1)=3;
                             end
                        end
                        if p_burn_matrix(2,1)>p_thresh
                            if old_forest(i,j-1)~=1 && old_forest(i,j-1)~=4 
                                new_forest(i,j-1)=3;
                            end
                        end
                        if p_burn_matrix(2,3)>p_thresh
                            if old_forest(i,j+1)~=1 && old_forest(i,j+1)~=4 
                                new_forest(i,j+1)=3;
                            end
                        end
                         if p_burn_matrix(3,1)>p_thresh
                             if old_forest(i+1,j-1)~=1 && old_forest(i+1,j-1)~=4 
                                new_forest(i+1,j-1)=3;
                             end
                         end
                         if p_burn_matrix(3,2)>p_thresh
                             if old_forest(i+1,j)~=1 && old_forest(i+1,j)~=4
                                new_forest(i+1,j)=3;
                             end
                         end
                          if p_burn_matrix(3,3)>p_thresh                      
                              if old_forest(i+1,j+1)~=1 && old_forest(i+1,j+1)~=4
                                new_forest(i+1,j+1)=3;
                              end
                          end 
                         new_forest(i,j)=4;
                             
                        
                    end
               end
          end
          new_forest(ignit_x-3:ignit_x+3,ignit_y-3:ignit_y+3)
   
  %%Simulation
    x=1:372; y=1:372;
    surf(x,y,new_forest,new_forest);
    view(360,90);
    colormap([1 0 1;0 1 0;1 0 0;0 0 0]);
    colorbar
    caxis([1 4]);
    axis([1,length(x),1,length(y),1,4])
    shading interp
    title(sprintf('Step = %.0f',gen))
    drawnow;
    gen=gen+1;
    forest=new_forest;
    
end
end
    
   

    
    




