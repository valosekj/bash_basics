function display_bvecs(bvec_file)
%
% Function for simple 3D visualisation of bvec DWI file, inspired by:
%       https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/eddy#eddy_--_a_tool_for_correcting_eddy_currents_and_movements_in_diffusion_data
% 
% Jan Valosek, fMRI lab, Olomouc
%

    bvecs = load(bvec_file);
    
    sprintf('Total number of bvecs: %i', size(bvecs,2))
    
    % get b0
    [C, ia, ic] = unique(bvecs' == 0,'rows');
    % count them
    a_counts = accumarray(ic,1);
    sprintf('Nnmber of b0: %i', a_counts(2))
    
    figure('position',[100 100 500 500]);
    hold on
    % individual points
    plot3(bvecs(1,:),bvecs(2,:),bvecs(3,:),'*r');
    % line plot
    for ind = 1:size(bvecs,2)
        plot3([bvecs(1,ind),0],[bvecs(2,ind),0],[bvecs(3,ind),0],'k')
    end

    hold off
    axis([-1 1 -1 1 -1 1]);
    xlabel('x')
    ylabel('y')
    zlabel('z')
    axis vis3d;
    rotate3d

end