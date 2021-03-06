function Bsignranktest(y,x,rope)
include("Tests/heaviside.jl")

nsamples=150000

#Dirichlet process prior strength
s=0.5

#differences
zm=y-x
nm=length(zm)

#
z0=0 #to check sensitivity to prior zet also z0=-Inf and z0=Inf


z=[zm;z0]
n=nm+1

if rope>0
	X=repmat(z,1,n);
	Y=repmat(-z'+2*rope,n,1);

	Aright = heaviside(X-Y)


	X=repmat(-z,1,n);
	Y=repmat(z'+2*rope,n,1);

	Aleft = heaviside(X-Y)


	dataresl=zeros(3,nsamples)
	dataresu=zeros(3,nsamples)

	for i=1:nsamples
	    data = rand(Dirichlet([ones(1,nm) s][:]),1)'

    	dataresl[3,i]=dot((data[:,1:end]*Aright)[:],(data[:,1:end])[:]) #+(2-data[:,end][1])*data[:,end][1]/2
    	dataresl[1,i]=dot((data[:,1:end]*Aleft )[:],(data[:,1:end])[:]) #+(2-data[:,end][1])*data[:,end][1]/2
    	dataresl[2,i]=1- dataresl[1,i]- dataresl[3,i]
    	#data12u[i,:]=(data12l[i]+(data1[:,end].*(2-data1[:,end])))[:]
	end

else

	X=repmat(z,1,n)
	Y=repmat(-z',n,1)

	A = heaviside(X-Y)

	dataresl=zeros(2,nsamples)
	dataresu=zeros(2,nsamples)

	for i=1:nsamples
	    data = rand(Dirichlet([ones(1,n) s][:]),1)'
	    dataresl[2,i]=dot((data[:,1:end-1]*A)[:],(data[:,1:end-1])[:])
	    dataresl[1,i]=1- dataresl[2,i]
	end

end



return dataresl

end
