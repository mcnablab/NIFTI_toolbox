function [ file ] = open_nii( filename )    
if(exist([filename '.gz']))
    gunzip([filename '.gz']);
    delete([filename '.gz']);
elseif(filename(end-2:end) == '.gz')
    gunzip([filename]);
    delete([filename]);
    filename = filename(1:end-3);
end

%same as open_nifti except no user interface
file=load_untouch_nii([filename]);
if file.hdr.dime.scl_slope~=0
%convert image data to type single and make corresponding changes in hdr
%file
file.img=single(file.img);
file.hdr.dime.bitpix=32;
file.hdr.dime.datatype=16;


%rescale image data
file.img=file.img*file.hdr.dime.scl_slope+file.hdr.dime.scl_inter;

%change nifti hdr accordingly
file.hdr.dime.glmax=file.hdr.dime.glmax*file.hdr.dime.scl_slope+file.hdr.dime.scl_inter;
file.hdr.dime.glmin=file.hdr.dime.glmin*file.hdr.dime.scl_slope+file.hdr.dime.scl_inter;
file.hdr.dime.scl_slope=0;

end

