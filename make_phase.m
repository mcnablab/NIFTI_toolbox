%Reconstruct phase data
%This program inputs either real and imaginary data in nifti format and spits out the
%reconstructed phase data in nifti format

%load real component
fprintf('choose real component \n')
[filename,pathname]=uigetfile('*.nii');
reality=load_untouch_nii([pathname filename]);

%convert image data to type single and make corresponding changes in hdr
%file
reality.img=single(reality.img);
reality.hdr.dime.bitpix=32;
reality.hdr.dime.datatype=16;

if reality.hdr.dime.scl_slope~=0
%rescale image data
reality.img=reality.img*reality.hdr.dime.scl_slope+reality.hdr.dime.scl_inter;

%change nifti hdr accordingly
reality.hdr.dime.glmax=reality.hdr.dime.glmax*reality.hdr.dime.scl_slope+reality.hdr.dime.scl_inter;
reality.hdr.dime.glmin=reality.hdr.dime.glmin*reality.hdr.dime.scl_slope+reality.hdr.dime.scl_inter;
reality.hdr.dime.scl_slope=0;
end

%----------------------------------------------------------------------------

%load imaginary component
fprintf('choose imaginary component \n')
[filename, pathname]=uigetfile('*.nii');
imagination=load_untouch_nii([pathname, filename]);

%convert image data to type single and make corresponding changes in hdr
%file
imagination.img=single(imagination.img);
imagination.hdr.dime.bitpix=32;
imagination.hdr.dime.datatype=16;

if imagination.hdr.dime.scl_slope~=0
%rescale image data
imagination.img=imagination.img*imagination.hdr.dime.scl_slope+reality.hdr.dime.scl_inter;

%change nifti hdr accordingly
imagination.hdr.dime.glmax=imagination.hdr.dime.glmax*imagination.hdr.dime.scl_slope+reality.hdr.dime.scl_inter;
imagination.hdr.dime.glmin=imagination.hdr.dime.glmin*imagination.hdr.dime.scl_slope+reality.hdr.dime.scl_inter;
imagination.hdr.dime.scl_slope=0;
end

%----------------------------------------------------------------------------

%create complex data
ims=reality.img-imagination.img*j;

%----------------------------------------------------------------------------

%get phase data from complex
phaseims=angle(ims);

%save as nifti
phase=reality;
phase.img=phaseims;

fprintf('choose save location \n')
location=uigetdir;
fprintf('saving nifti \n')
save_untouch_nii(phase, [location '/phase.nii'])
fprintf('finished \n')

