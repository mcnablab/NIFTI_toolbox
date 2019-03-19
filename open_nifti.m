function [file]=open_nifti
[filename,pathname]=uigetfile('*.nii*');
if strcmp(filename(end-2:end),'.gz')
    gunzip([pathname filename]);
    delete([pathname filename]);
    file=load_untouch_nii([pathname filename(1:end-3)]);
else
file=load_untouch_nii([pathname filename]);
end
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
end

