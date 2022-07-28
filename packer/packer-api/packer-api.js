{
    "builders": [
        {
            "type": "amazon-ebs",
            "access_key":"your-key",
            "secret_key": "your-key",
            "region": "us-east-1",
            "ami_name": "21d-api-exchangeapp",
            "source_ami": "ami-0c4f7023847b90238",
            "instance_type": "t2.micro",
            "ssh_username": "ubuntu"

        }
    ],
    "provisioners": [

        {
            "type": "file",
            "source": "../api",
            "destination": "~/"
        },
        {
            "type": "shell",
            "inline": [
                "mkdir /home/ubuntu/packer-api"
            ]
           
        },
        {
            "type": "file",
            "source": "./exchange-api.service",
            "destination": "/tmp/"
        },
        {
            "type": "file",
            "source": "./deamon-script.sh",
            "destination": "/home/ubuntu/packer-api/"
        },

        {
            "type": "shell",
            "inline": [
                "sudo mv /tmp/exchange-api.service /etc/systemd/system/"
            ]
           
        },

        {
            "type": "shell",
            "script": "./commands.sh"
        }

    ]

}
