{
    "builders": [
        {
            "type": "amazon-ebs",
            "access_key":"your-key",
            "secret_key": "your-secret-key",
            "region": "us-east-1",
            "ami_name": "21d-web-exchangeapp",
            "source_ami": "ami-0c4f7023847b90238",
            "instance_type": "t2.micro",
            "ssh_username": "ubuntu"

        }
    ],
    "provisioners": [

        {
            "type": "file",
            "source": "../web",
            "destination": "~/"
        },
        {
            "type": "shell",
            "inline": [
                "mkdir /home/ubuntu/packer-web"
            ]
           
        },
        {
            "type": "file",
            "source": "./exchange-web.service",
            "destination": "/tmp/"
        },
        {
            "type": "file",
            "source": "./deamon-script.sh",
            "destination": "/home/ubuntu/packer-web/"
        },

        {
            "type": "shell",
            "inline": [
                "sudo mv /tmp/exchange-web.service /etc/systemd/system/"
            ]
           
        },

        {
            "type": "shell",
            "script": "./commands.sh"
        }    
    ]
}
