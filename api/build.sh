echo "starting build"
python3 -m virtualenv venv 

venv/Scripts/activate

pip3 install -r requirements.txt -t dist/.

cd dist; zip -rv ../lambda.zip ./*; cd ..
cd src; zip -rv ../lambda.zip *.py; cd ..

echo "finish build"

